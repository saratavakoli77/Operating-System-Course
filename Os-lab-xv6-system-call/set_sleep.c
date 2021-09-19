#include "types.h"
#include "stat.h"
#include "user.h"

int
diff(int time1, int time2)
{
  int res = 0;
  int temp1, temp2;
  temp1 = time1%100;
  time1 /= 100;
  temp2 = time2%100;
  time2 /= 100;
  res = temp2 - temp1;

  temp1 = time1%100;
  time1 /= 100;
  temp2 = time2%100;
  time2 /= 100;
  res += (temp2 - temp1) * 60;

  temp1 = time1%100;
  time1 /= 100;
  temp2 = time2%100;
  time2 /= 100;
  res += (temp2 - temp1) * 3600;

  return res;
}

int
main(int argc, char *argv[])
{
  if(argc <= 2) {
    printf(1, "set_sleep: not enough argument\n");
    exit();
  }
  int option = atoi(argv[1]);
  int delay = atoi(argv[2]);
  int firstTime, secTime;
  firstTime = get_date(); 
  if (option == 1)
    set_sleep(delay);
  else
    set_sleep_with_delay(delay);

  secTime = get_date(); 
  printf(1, "diff = %d\n", diff(firstTime, secTime));
  
  exit();
}

