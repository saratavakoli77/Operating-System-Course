#include "types.h"
#include "stat.h"
#include "user.h"

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
main(int argc, char *argv[])
{
  if(argc <= 2){
      printf(1, "set_priority: not enough argument\n");
    exit();
  }

  int pid = atoi(argv[1]);
  set_priority(pid, argv[2]);
  exit();
}
