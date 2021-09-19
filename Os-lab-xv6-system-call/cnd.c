#include "types.h"
#include "stat.h"
#include "user.h"

char buf[16];

int
main(int argc, char *argv[])
{
  if(argc <= 1){
    printf(1, "cnd: not enough argument\n");
    exit();
  }
  unsigned long temp;
  int number = atoi(argv[1]);

  asm("movl %%esi,%0":"=r"(temp));
  asm("movl %0,%%esi"::"r"(number));
  asm("movl $22,%eax;");
  asm("int $0x40");
  asm("movl %0,%%esi"::"r"(temp));

  number = temp;
  temp = number;
  exit();
}
