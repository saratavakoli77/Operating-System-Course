#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

float
stof(char *p) {
  int i, num = 0, num2 = 0, pnt_seen = 0, x = 0, y = 1; 
  float f2, f3;
  for (i = 0; p[i]; i++)
    if (p[i] == '.') {
      pnt_seen = i;
      break;
    }
  for (i = 0; p[i]; i++) {
    if (i < pnt_seen) num = num * 10 + (p[i] - 48);
    else if (i == pnt_seen) continue;
    else {
      num2 = num2 * 10 + (p[i] - 48);
      ++x;
    }
  }
  for (i = 1; i <= x; i++) 
    y = y * 10;
  f2 = num2 / (float) y;
  f3 = num + f2;
  return f3;
}

int
sys_print_information(void)
{
  print_information();
  return 1;
}

int
sys_set_priority(void)
{
  int pid;
  char* priorityArg;
  if(argint(0, &pid) < 0)
    return -1;
  
  if(argstr(1, &priorityArg) < 0)
    return -1;

  float priority = stof(priorityArg);
  set_priority(pid, priority);
  return (pid);
}

int
sys_set_tickets(void)
{
  int tickets, pid;

  if(argint(0, &pid) < 0)
    return -1;
  
  if(argint(1, &tickets) < 0)
    return -1;

  set_tickets(pid, tickets);
  return (pid);
}


int
sys_change_queue(void)
{
  int level, pid;

  if(argint(0, &pid) < 0)
    return -1;
  
  if(argint(1, &level) < 0)
    return -1;

  change_queue(pid, level);
  return (pid);
}