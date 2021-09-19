#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int res;
  if(fork() == 0)
  {
    if(fork()!=0)
    {
       wait();
    }
    else
    {
     sleep(100); 
    }
   
  }
  else {
    if(fork()!=0){ 
      wait();
    }
    else
    {
      sleep(500);
    }
    wait();
  }
  if(getpid()==6){
    res = get_children(2);
    printf(1, "children: %d\n", res);
  }
  exit();
}
