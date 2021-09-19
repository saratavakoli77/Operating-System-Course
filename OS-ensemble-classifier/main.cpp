#include <iostream>
#include "ensemble.h"

using namespace std;

int calculate_number_of_files(string addr) {
    int n = 0;
    ifstream file;
    while (1) {
        file.open(addr + "/classifier_" + to_string(n) + ".csv");
        if (file.is_open()) {
            file.close();
            n++;
        } else  {
            break;
        }
    }
    return n;
}

int main(int argc, char *argv[])
{
    string addr = argv[2];
    int number_of_files = calculate_number_of_files(addr);
    Ensemble* e = new Ensemble(argv[1], argv[2], number_of_files);
    e->create_classifiers();
}