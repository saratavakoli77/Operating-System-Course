#ifndef Condition_H
#define Condition_H Condition_H

#include <semaphore.h>

class Condition
{
// private:
public:
    sem_t s;
    int count;
// public:
    Condition();
};

#endif