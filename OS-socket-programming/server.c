#include <stdio.h> 
#include <string.h>
#include <stdlib.h> 
#include <errno.h> 
#include <unistd.h>
#include <arpa/inet.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <sys/time.h>
#include <fcntl.h>
#include <libgen.h>
#include <signal.h>
#include <stdbool.h>
	
#define TRUE 1 
#define FALSE 0 
#define PORT 8888 
#define HEARTBEAT_MSG "8000"
#define SERVER_ADDR "127.0.0.1"
#define SERVER_PORT 8888
#define ADDR "239.255.255.250"

struct sockaddr_in hearbeat_add;
int heartbeat_sock;
int activity;
char* port;

bool heartbeating = false;

int log_file;


void initializeHeartbeatSocket()
{
    if ((heartbeat_sock = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        write(2, "fail to open socket", 20);
		write(log_file, "fail to open socket", 20);
        return;
    }
    hearbeat_add.sin_family = AF_INET;
    hearbeat_add.sin_port = htons(atoi(port));
    hearbeat_add.sin_addr.s_addr = inet_addr(ADDR);
}

void send_heartbeat()
{
    const char *msg = HEARTBEAT_MSG;
    if (sendto(heartbeat_sock, msg, strlen(msg), 0, (struct sockaddr *)&hearbeat_add, sizeof(hearbeat_add)) > -1)
        if (!heartbeating)
        {
            write(1, "Server is heartbeating.\n", 25);
			write(log_file, "Server is heartbeating.\n", 25);
            heartbeating = true;
        }
    signal(SIGALRM, send_heartbeat);
    alarm(1);
}

int master_socket;

void create_master_socket() {
	int opt = TRUE;
	if( (master_socket = socket(AF_INET , SOCK_STREAM , 0)) == 0) 
	{ 
		write(2, "socket failed", 14);
		write(log_file, "socket failed", 14);
		exit(EXIT_FAILURE); 
	} 

	if( setsockopt(master_socket, SOL_SOCKET, SO_REUSEADDR, (char *)&opt, 
		sizeof(opt)) < 0 ) 
	{ 
		write(2, "fail to set socket opt", 23);
		write(log_file, "fail to set socket opt", 23);
		exit(EXIT_FAILURE); 
	} 	
}

struct sockaddr_in address;

void init_address() {
	address.sin_family = AF_INET; 
	address.sin_addr.s_addr = INADDR_ANY; 
	address.sin_port = htons( atoi(port) ); 
		
	if (bind(master_socket, (struct sockaddr *)&address, sizeof(address))<0) 
	{ 
		write(2, "bind failed", 12);
		write(log_file, "bind failed", 12);
		exit(EXIT_FAILURE); 
	} 
	printf("Listener on port %d \n", atoi(port)); 
		
	if (listen(master_socket, 10) < 0) 
	{ 
		perror("listen");
		write(2, "listen failed", 14);
		write(log_file, "listen failed", 14);
		exit(EXIT_FAILURE); 
	} 

	write(1,"Waiting for connections ...",28); 
}


void create_clients_and_handle_commands() {
	int new_socket , client_socket[30] , 
		max_clients = 30 , activity, i , valread , sd; 
	int max_sd;
	int addrlen = sizeof(address);
		
	char buffer[1025];
	
	fd_set readfds; 
		
	char *message = "Begin \r\n"; 
	
	for (i = 0; i < max_clients; i++) 
	{ 
		client_socket[i] = 0; 
	}
		
	while(TRUE) 
	{ 
		FD_ZERO(&readfds); 
	
		FD_SET(master_socket, &readfds); 
		max_sd = master_socket; 
			
		for ( i = 0 ; i < max_clients ; i++) 
		{ 
			sd = client_socket[i]; 
			if(sd > 0) 
				FD_SET( sd , &readfds); 
				
			if(sd > max_sd) 
				max_sd = sd;
		} 

		activity = select( max_sd + 1 , &readfds , NULL , NULL , NULL); 
	
		if ((activity < 0)) 
		{ 
			continue; 
		} 
		
		if (FD_ISSET(master_socket, &readfds)) 
		{ 
			if ((new_socket = accept(master_socket, 
					(struct sockaddr *)&address, (socklen_t*)&addrlen))<0) 
			{ 
				write(2, "accept failed", 14);
				write(log_file, "accept failed", 14);
				exit(EXIT_FAILURE);
			} 
			
			write(1, "New connection added", 21);
			write(log_file, "New connection added", 21);
		
			if( send(new_socket, message, strlen(message), 0) != strlen(message) ) 
			{ 
				write(2, "send_failed", 12);
				write(log_file, "send_failed", 12);
			} 
				
			write(1, "Welcome message sent successfully", 34); 
				
			for (i = 0; i < max_clients; i++) 
			{ 
				if( client_socket[i] == 0 ) 
				{ 
					client_socket[i] = new_socket; 
					write(1, "Socket added to list of sockets", 32); 
					write(log_file, "Socket added to list of sockets", 32); 
					break; 
				} 
			} 
		} 
			
		for (i = 0; i < max_clients; i++) 
		{ 
			sd = client_socket[i]; 
				
			if (FD_ISSET( sd , &readfds)) 
			{
				if ((valread = read( sd , buffer, 1024)) == 0) 
				{
					getpeername(sd , (struct sockaddr*)&address , \ 
						(socklen_t*)&addrlen); 
					write(1, "Host disconnected", 18); 
						
					close( sd ); 
					client_socket[i] = 0; 
				} else {
					buffer[valread] = '\0';
					if (strncmp(buffer, "upload", 6) == 0) {
						write(1, "upload start in server", 23);
						write(log_file, "upload start in server", 23);
						char file_name[1024];
						memset(file_name, '\0', sizeof(file_name));
					
						int i = 0;
						int j = 0;
						while(buffer[i] != ' ') {
							i++;
						}
						i++;
						while(buffer[i] != '\0' && buffer[i] != '\n' && buffer[i] != '\r') {
							file_name[j] = buffer[i];
							i++;
							j++;
						}
						char* file_base_name = basename(file_name);
						
						char data[8192];
						memset(data, '\0', sizeof(data));
						i++;
						int m = 0;
						while (buffer[i] != '\0') {
							data[m] = buffer[i];
							m++;
							i++;
						}
						int file = open(file_base_name, O_WRONLY | O_CREAT, 0777);
						if(file == -1) {
							write(2, "open failed", 12);
							write(log_file, "open failed", 12);
							exit(EXIT_FAILURE);
						}
						int n_bytes_write = write(file, data, m-1);
						if (n_bytes_write != m-1 || n_bytes_write == -1) {
							write(2, "write failed", 13);
							write(log_file, "write failed", 13);
							exit(EXIT_FAILURE);
						}
						write(1, "upload compelete", 17);
						write(log_file, "upload compelete", 17);
					} else if (strncmp(buffer, "download", 8) == 0) {
						write(1, "download start in server", 25);
						write(log_file, "download start in server", 25);
						char file_name[1024];
						memset(file_name, '\0', sizeof(file_name));
						int i = 0;
						int j = 0;
						while(buffer[i] != ' ') {
							i++;
						}
						i++;
						while(buffer[i] != '\0' && buffer[i] != '\n' && buffer[i] != '\r') {
							file_name[j] = buffer[i];
							i++;
							j++;
						}

						int file = open(file_name, O_RDONLY);
						if(file == -1) {
							write(2, "open failed", 12);
							write(log_file, "open failed", 12);
							int error = write(sd, "File not found", 14);
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
						int k = 0;
						while(data[k] != '\0' && data[k] != '\n' && data[k] != '\r') {
							k++;
						}
						int n_bytes_w = write(sd, data, k);
						if (n_bytes_w != k) {
							write(2, "write failed", 13);
							write(log_file, "write failed", 13);
							exit(EXIT_FAILURE);
                        }
					}
				}
			}
		}
	}
}
	
int main(int argc , char *argv[]) 
{
	if (argc != 2)
    {
        char er[30] = "Parametrs aren't inough\n";
        write(2, er, 30);
        exit(0);
    }
    port = argv[1];
	log_file = open("log.txt", O_WRONLY | O_CREAT, 0777);
	if(log_file == -1){
		write(2,"open log file failed",21);
	}
	initializeHeartbeatSocket();
    send_heartbeat();
	create_master_socket();
	init_address();
	create_clients_and_handle_commands();

	return 0; 
} 
