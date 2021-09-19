#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char buf[512];

void
cptFileToFile(int fd_src, int fd_dest)
{
  int n;

  while((n = read(fd_src, buf, sizeof(buf))) > 0) {
    if (write(fd_dest, buf, n) != n) {
      printf(1, "cpt: write error\n");
      exit();
    }
  }
}

void
cpt(int fd_src, int fd_dest)
{
    int n;

  n = read(fd_src, buf, sizeof(buf));
  if (write(fd_dest, buf, n) != n) {
    printf(1, "cpt: write error\n");
    exit();
  }
}

int
main(int argc, char *argv[])
{
  int fd0, fd1;

  if(argc <= 1){
    printf(1, "cpt: missing file operand :/\n");
    exit();
  }

  if(argc == 2){
    if((fd0 = open(argv[1], O_CREATE|O_RDWR)) < 0){
        printf(1, "cpt: cannot open %s :/\n", argv[1]);
        exit();
    }
    cpt(0, fd0);
    close(fd0);
  }

  if(argc == 3){

    if((fd1 = open(argv[1], O_RDONLY)) < 0){
        printf(1, "cpt: cannot open %s :/\n", argv[1]);
        exit();
    }
    if((fd0 = open(argv[2], O_CREATE|O_RDWR)) < 0){
        printf(1, "cpt: cannot open %s :/\n", argv[2]);
        exit();
    }
    cptFileToFile(fd1, fd0);
    close(fd0);
    close(fd1);
  }

  exit();
}
