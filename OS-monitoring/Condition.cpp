#include "Condition.h"
#include <iostream>
#include <semaphore.h>

using namespace std;

Condition::Condition() {
    count = 0;
    sem_init(&s, 0, 1);
}