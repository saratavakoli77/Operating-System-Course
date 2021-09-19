#include "Monitor.h"
#include <iostream>
#include <unistd.h>
#include <chrono>
#include <time.h>
#include <math.h>

using namespace std::chrono;
using namespace std;

Monitor::Monitor() {
    sem_init(&mutex, 0, 1);
    next = new Condition();
}

Monitor::Monitor(Point _p) {
    sem_init(&mutex, 0, 1);
    next = new Condition();
    p = _p;
}

void Monitor::wait(Condition* inCondition) {
    if (next->count > 0) {
        signal(next);
    } else {
        sem_post(&mutex);
    }
    sem_wait(&(inCondition->s));
    inCondition->count++;
}

void Monitor::signal(Condition* inCondition) {
    if (inCondition->count > 0) {
        next->count++;
        sem_post(&(inCondition->s));
        wait(next);
        next->count--;
    }
}

void Monitor::moveInPath(Car* car) {
    sem_wait(&mutex);
    car->currentNode = p;
    milliseconds t = duration_cast< milliseconds >(
        system_clock::now().time_since_epoch()
    );
    car->begin = t.count();

    double emission = 0;
    for (double k = 0; k < 10000000; k++) {
        emission += floor(k/(1000000*car->p*p.h));
    }
    car->emission = emission;
    milliseconds t2 = duration_cast< milliseconds >(
        system_clock::now().time_since_epoch()
    );
    car->end = t2.count();

    sem_wait(&totalEmissionSem);
    totalEmission += emission;
    car->totalEmission += totalEmission;
    sem_post(&totalEmissionSem);

    if (next->count > 0) {
        signal(next);
    } else {
        sem_post(&mutex);
    }
}