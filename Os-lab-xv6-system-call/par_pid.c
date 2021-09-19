#include "types.h"
#include "stat.h"
#include "user.h"

void
par_pid()
{
  printf(1, "current pid %d\n", getpid());
  int pid1 = fork();
  if (pid1 == 0) {
      printf(1, "result is: %d\n", get_parent_id());
  }
  else {
      wait();
  }
}

int
main(int argc, char *argv[])
{
  par_pid();
  exit();
}
