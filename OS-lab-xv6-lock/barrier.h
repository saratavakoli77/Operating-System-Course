// #include "proc.h"
struct barrier {
    // int bid;
    // int lastIndex;
    struct spinlock sl;
    struct spinlock countLock;
    int waitCount;
    int isBarInited;
} bar;
