#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "path.h"

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

int 
sys_count_num_of_digits(void)
{
  int number, res;
  asm("movl %%esi,%0":"=r"(number));
  res = count_num_of_digits(number);
  cprintf("count of digits : %d\n", res);
  return count_num_of_digits(number);
}

int
sys_get_parent_id(void)
{
  return get_parent_id();
}

int
sys_set(void)
{
  char *newPath;
  if(argstr(0, &newPath) < 0)
    return -1;
  
  set(newPath);
  return 1;
}

int
sys_set_sleep(void)
{
  int n, h, m, s;
  if(argint(0, &n) < 0)
    return -1;
  h = n / 3600;
  n = n - h * 3600;
  m = n / 60;
  n = n - m * 60;
  s = n;

  systemTime time1, time2;
  cmostime(&time1);
  sti();
  while (1) {
    cmostime(&time2);
    if(time2.hour == time1.hour + h &&
       time2.minute == time1.minute + m && 
       time2.second == time1.second + s) {
      break;
    }
  }

  return 0;
}

int
sys_get_date(void)
{
  systemTime time;
  cmostime(&time);
  int res = 1;
  res = res*100 + time.hour;
  res = res*100 + time.minute;
  res = res*100 + time.second;
  return res;
}

int
sys_set_sleep_with_delay(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  n = n*100;

  uint ticks0;
  ticks0 = ticks;
  while (1) {
    sti();
    if (ticks - ticks0 >= n) {
      break;
    }
  }
  return 0;
}

int
sys_get_children(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return get_children(pid);
}