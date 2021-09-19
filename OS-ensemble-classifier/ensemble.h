#ifndef Ensemble_H
#define Ensemble_H Ensemble_H

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <unistd.h>
#include <sys/wait.h>
using namespace std;

class Ensemble
{
public:
    Ensemble(string, string, int);
    void create_classifiers();
    string create_classifiers_name(int);
private:
    int classifier_number;
    string weights_path;
    string dataset_path;
    string validation_path;
};

#endif