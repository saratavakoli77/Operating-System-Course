#include "types.h"
#include "stat.h"
#include "user.h"

int
main()
{
    set_priority(getpid(),"9");
    change_queue(getpid(), 2);
    int p1 = fork();
    
    if (p1 == 0) {
        int a = 1;
        while (1) {
            a++;
            if (a == 20000000) break;
        }
        sleep(1000);

    } else {
        set_priority(p1, "5");
        set_tickets(p1, 45);
        change_queue(p1, 3);
        int a = 1;
        while (1) {
            a++;
            if (a == 5000) {
                change_queue(p1, 2);
            }
        }
        wait();
    }
    
    exit();
}
