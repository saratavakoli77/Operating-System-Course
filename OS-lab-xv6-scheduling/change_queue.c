#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if(argc <= 2){
      printf(1, "change_queue: not enough argument\n");
    exit();
  }
  // int i;
  // i = fork();
  // if (i == 0) {
  //   sleep(1000);
  // } else {
  //   set_tickets(50, i);
  //   print_information();
  //   wait();
  // }
  int pid = atoi(argv[1]);
  int level = atoi(argv[2]);
  change_queue(pid, level);
  exit();
}
