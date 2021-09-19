#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    // int parentId = getpid();
    // init_barrier();
    int pid = fork();
    if(pid == 0)
    {
        int a = 1;
        for(long int i=0; i<214748; i++)
        {
            a = a*i;
        }

    }
    else
    {
        pid = fork();
        if(pid == 0)
        {
            int pidN = fork();
            if(pidN == 0)
            {
                for(int i=0; i<1000; i++)
                {

                }

            }
            else
            {
                for(int i=0; i<20000; i++)
                {

                }
                
            }
            
        }
        else
        {
           // wait();
        }
        //wait();   
    }
    
    barrier(4);
    barrier(4);
    barrier(4);
    wait();
    wait();
    wait();
    exit();
}
