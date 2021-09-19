#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <signal.h>
#include <stdbool.h>
#include <sys/time.h>
#include <errno.h> 

#define IP_PROTOCOL 0 
#define LOCAL "127.0.0.1" 
#define PORT 8888 

char* port;
char* hb_port;
char* arg2;
int hb_fd;
char* server_port;
bool is_broadcasting = false;
int broadcast_write_fd;
struct sockaddr_in broadcast_write_addr;
char broadcast_msg[1025];
fd_set readfds;
int max_sd = 0;
int activity;
int broadcast_read_fd;
int client_socket;
int log_file;

bool is_server_up() {
    char rec[256];
    int rec_len = recvfrom(hb_fd, rec, 255, 0, NULL, 0);
    if ((rec_len > 0)) {
        rec[rec_len] = '\0';
        write(1, "server information :", 21);
        write(1, rec, strlen(rec));
        write(1, "\n", 1);
		server_port = rec;
        // close(broadcastFD);
        return true;
    }
    return false;
}

void create_and_connect_socket() {
	int nBytes, rec, connection_status; 
	struct sockaddr_in addr_con; 
	char server_message[100];

	bzero(&addr_con, sizeof(addr_con));

	addr_con.sin_family = AF_INET;
	addr_con.sin_port = htons(atoi(server_port));
	addr_con.sin_addr.s_addr = inet_addr(LOCAL);

	client_socket = socket(AF_INET, SOCK_STREAM, 0); 

	if (client_socket < 0) {
		write(2, "file descriptor not received!  ", 32);
		write(log_file, "file descriptor not received!  ", 32);
	} else {
		write(1, "file descriptor received!  ", 28);
		write(log_file, "file descriptor received!  ", 28);
	}

	connection_status= connect(client_socket, (struct sockaddr *)&addr_con, sizeof(addr_con));
	if (connection_status == -1) {
		write(2, "connection failed  ", 20);
		write(log_file, "connection failed  ", 20);
        exit(EXIT_FAILURE);
	}

	rec = recv(client_socket, &server_message, sizeof(server_message), 0);
	if (rec < 0) {
		write(2, "recive failed  ", 16);
		write(log_file, "recive failed  ", 16);
		exit(EXIT_FAILURE);
	}

}

int counter = 0;

void send_broadcast_msg(){
	if (counter < 4) {
		if (sendto(broadcast_write_fd, broadcast_msg, strlen(broadcast_msg), 0, (struct sockaddr *)&broadcast_write_addr, sizeof(broadcast_write_addr)) > -1)
		{
			if (!is_broadcasting)
			{
				write(1, "client is broadcasting...\n", 27);
				write(log_file, "client is broadcasting...\n", 27);
				is_broadcasting = true;
			}
		}
		signal(SIGALRM, send_broadcast_msg);
		alarm(1);
		counter++;
	}
}

void handle_command() {
	char command[8192];

	while(1) {
		FD_ZERO(&readfds);
		FD_SET(STDIN_FILENO, &readfds);
		if (max_sd < STDIN_FILENO)
			max_sd = STDIN_FILENO;
		FD_SET(broadcast_read_fd, &readfds);
		if (max_sd < broadcast_read_fd)
			max_sd = broadcast_read_fd;

		activity = select(max_sd + 1, &readfds, NULL, NULL, NULL);
        if (activity < 0 && errno == EINTR)
        {
			write(1, "signal\n", 8);
			write(log_file, "signal\n", 8);
            continue;
        }

		if (FD_ISSET(broadcast_read_fd, &readfds)) {
            write(1, "broadcast reader  \n",20);
            write(log_file, "broadcast reader  \n",20);
            char rec_str[256];
            int rec_str_len;
            if ((rec_str_len = recvfrom(broadcast_read_fd, rec_str, 255, 0, NULL, 0)) > 0) {
                rec_str[rec_str_len] = '\0';
                write(1, "client information :", 21);
                write(1, rec_str, strlen(rec_str));
                write(1, "\n", 1);
                server_port = rec_str;
            }
        }

		if (FD_ISSET(STDIN_FILENO, &readfds)) {

			memset(command, '\0', sizeof(command));
			read(0, command, sizeof(command));
			
			if ( strncmp(command, "upload", 6) == 0) {
				if (is_server_up()) {
					write(1, "upload start in client", 23);
					write(log_file, "upload start in client", 23);
					char file_name[1024];
					memset(file_name, '\0', sizeof(file_name));
					int i = 0;
					int j = 0;
					while(command[i] != ' ') {
						i++;
					}
					i++;
					while(command[i] != '\0' && command[i] != '\n' && command[i] != '\r') {
						file_name[j] = command[i];
						i++;
						j++;
					}

					int file = open(file_name, O_RDONLY);

					if(file == -1){
						write(2, "open failed", 12);
						write(log_file, "open failed", 12);
						// exit(EXIT_FAILURE);
						continue;
					}

					char data[8192];
					memset(data, '\0', sizeof(data));
					int n_bytes = read(file, data, sizeof(data));
					if (n_bytes == -1) {
						write(2, "read failed", 12);
						write(log_file, "read failed", 12);
						exit(EXIT_FAILURE);
					}
					i++;
					int m = 0;
					while (data[m] != '\0') {
						command[i] = data[m];
						m++;
						i++;
					}
					write(client_socket, &command, i);
				} else {
					write(1, "server is not alive", 20);
					write(log_file, "server is not alive", 20);
					return;
				}
			} else if (strncmp(command, "download", 8) == 0) {
				write(1, "download start in client", 25);
				write(log_file, "download start in client", 25);
				char file_name[1024];
				memset(file_name, '\0', sizeof(file_name));
				int i = 0;
				int j = 0;
				while(command[i] != ' ') {
					i++;
				}
				i++;
				while(command[i] != '\0' && command[i] != '\n' && command[i] != '\r') {
					file_name[j] = command[i];
					i++;
					j++;
				}
				
				if (is_server_up()) {
					write(1, "download start in client", 25);
					write(log_file, "download start in client", 25);
					int n_bytes_w = write(client_socket, &command, i);
					if (n_bytes_w != i) {
						write(2, "write failed", 13);
						write(log_file, "write failed", 13);
						exit(EXIT_FAILURE);
					}
					char data[8192];
					memset(data, '\0', sizeof(data));

					int r_bytes = read(client_socket, data, sizeof(data));
					if (r_bytes == -1 || r_bytes == 0) {
						write(2, "read failed", 12);
						write(log_file, "read failed", 12);
						exit(EXIT_FAILURE);
					}
					if (strcmp("File not found", data) == 0) {
						write(2, "File: No such file or directory", 32);
						continue;
					}
					int file = open(file_name, O_WRONLY | O_CREAT, 0777);
					if(file == -1){
						write(2, "open failed", 12);
						write(log_file, "open failed", 12);
						exit(EXIT_FAILURE);
					}
					int k = 0;
					while(data[k] != '\0' && data[k] != '\n' && data[k] != '\r') {
						k++;
					}
					int n_bytes_write = write(file, data, k);
					if (n_bytes_write == -1) {
						write(2, "write failed", 13);
						write(log_file, "write failed", 13);
						exit(EXIT_FAILURE);
					}
				} else {
					int n = 0;
					while (port[n] != '\n' && port[n] != '\r' && port[n] != '\0') {
						broadcast_msg[n] = port[n];
						n++;
					}
					n++;
					broadcast_msg[n] = ' ';
					n++;
					int f = 0;
					while(file_name[f] != '\0') {
						broadcast_msg[n] = file_name[f];
						n++;
						f++;
					}
					write(1, "Request send to all present clients  ", 38);
					write(log_file, "Request send to all present clients  ", 38);
					send_broadcast_msg();
					continue;
				}
			}
		}
	}
}

void create_bc_read_sock() {
    struct sockaddr_in addressOfSocket;
    char rec_str[256];
    int rec_str_len;
    if ((broadcast_read_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        write(2, "fail to open socket\n", 21);
        return;
    }
    int broadcast = 1;
    if (setsockopt(broadcast_read_fd, SOL_SOCKET, SO_REUSEADDR, &broadcast, sizeof(broadcast)) == -1)
    {
        write(2, "fail to set broadcast\n", 23);
        return;
    }

    addressOfSocket.sin_family = AF_INET;
    addressOfSocket.sin_port = htons(atoi(arg2));
    addressOfSocket.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(broadcast_read_fd, (struct sockaddr *)&addressOfSocket, sizeof(addressOfSocket)) < 0)
    {
        write(2, "fail to bind", 13);
        return;
    }

    struct ip_mreq mreq;
    mreq.imr_multiaddr.s_addr = inet_addr("239.255.255.251");
    mreq.imr_interface.s_addr = htonl(INADDR_ANY);
    if (setsockopt(broadcast_read_fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, (char *)&mreq, sizeof(mreq)) < 0)
    {
        write(2, "setsockopt", 11);
        return;
    }
}

void create_bc_write_sock() {
    if ((broadcast_write_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        write(1, "fail to open socket", 20);
        return;
    }
    broadcast_write_addr.sin_family = AF_INET;
    broadcast_write_addr.sin_port = htons(atoi(arg2));
    broadcast_write_addr.sin_addr.s_addr = inet_addr(arg2);
}

void create_hb_sock() {
    struct sockaddr_in addressOfSocket;
    char rec_str[256];
    int rec_str_len;
    if ((hb_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        write(2, "fail to open socket\n", 21);
        return;
    }
    int broadcast = 1;
    if (setsockopt(hb_fd, SOL_SOCKET, SO_REUSEADDR, &broadcast, sizeof(broadcast)) == -1)
    {
        write(2, "fail to set broadcast\n", 23);
        return;
    }

    addressOfSocket.sin_family = AF_INET;
    addressOfSocket.sin_port = htons(atoi(hb_port));
    addressOfSocket.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(hb_fd, (struct sockaddr *)&addressOfSocket, sizeof(addressOfSocket)) < 0)
    {
        write(2, "fail to bind", 13);
        return;
    }

    struct ip_mreq mreq;
    mreq.imr_multiaddr.s_addr = inet_addr("239.255.255.250");
    mreq.imr_interface.s_addr = htonl(INADDR_ANY);
    if (setsockopt(hb_fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, (char *)&mreq, sizeof(mreq)) < 0)
    {
        write(2, "setsockopt", 11);
        return;
    }
    float timeout = 4;
    struct timeval tv;
    tv.tv_sec = timeout;
    tv.tv_usec = timeout * 1000;
    if (setsockopt(hb_fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)) < 0)
    {
        write(1, "unable to set timeout", 22);
    }
}

int main(int argc,  char *argv[]) {

	if (argc != 4)
    {
        char er[30] = "Parametrs aren't inough\n";
        write(2, er, 30);
		exit(0);
    }

	hb_port = argv[1];
	arg2 = argv[2];
    port = argv[3];

	int nBytes, rec, connection_status;

	log_file = open("log.txt", O_WRONLY | O_CREAT, 0777);
	if(log_file == -1){
		write(2,"open log file failed",21);
	}

	create_hb_sock();
	bool test = is_server_up();
	if(test) {
		create_and_connect_socket();
		write(1, "Server is up\n", 14);
	} else {
		write(1, "Server is not up\n", 18);
	}

	create_bc_read_sock();
	create_bc_write_sock();
	send_broadcast_msg();
	handle_command();

	return 0; 
} 
