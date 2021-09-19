#include "types.h"
#include "stat.h"
#include "user.h"
#include "path.h"

char buf[16];

int
main(int argc, char *argv[])
{
  if(argc <= 2){
    printf(1, "set: not enough argument\n");
    exit();
  }
  set(argv[2]);
 // printf(1, "%s\n", argv[2]);
 // printf(1, "index= %d\n", indexPath);
  //for (int i = 0; i <= 1; i++)
   // printf(1, "here path is %s\n", PATH[i]);
  exit();
}
