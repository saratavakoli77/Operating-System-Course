#ifndef Classifier_H
#define Classifier_H Classifier_H

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
using namespace std;

class Classifier
{
public:
    Classifier(string, string);
    void set_weights_and_data();
    string calculate();
private:
    string weights_path_name;
    string input_data_path_name;
    vector<vector<double>> weights;
    vector<vector<double>> input_data;
};

#endif