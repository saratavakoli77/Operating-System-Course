#ifndef Monitor_H
#define Monitor_H Monitor_H

#include "Condition.h"
#include <semaphore.h>
#include <string>
#include <vector>
#include <ctime>
#include <thread>

extern double totalEmission;
extern sem_t totalEmissionSem;

using namespace std;

struct Point
{
    string source;
    string destination;
    int h;
};

struct Path
{
    // vector<string> pathSequence;
    vector<Point> pathSequence;
    int numOfCarsInSource;
    int id;
};

struct Car
{
    int id;
    Path carPath;
    Point currentNode;
    int p;
    time_t begin;
    time_t end;
    int num;
    long int emission;
    long int totalEmission;
};

class Monitor
{
private:
    Condition* next;
    sem_t mutex;
    int test = 0;
    
public:
    Monitor();
    Monitor(Point);
    void wait(Condition*);
    void signal(Condition*);
    void moveInPath(Car* car);
    Point p;
};


#endif