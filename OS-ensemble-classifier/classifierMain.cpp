#include <stdio.h>
#include <iostream>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <fstream>
#include <sstream>
#include <sys/types.h>
#include "classifier.h"

using namespace std;

void split_by_space(string s, string &classifier_path, string &dataset_path, string &fifo_path) {
    int i = 0;
    while (s[i] != '-') {
        classifier_path = classifier_path + s[i];
        i++;
    }
    i++;
    while (s[i] != '-') {
        dataset_path = dataset_path + s[i];
        i++;
    }
    i++;
    while (s[i] != '\0') {
        fifo_path = fifo_path + s[i];
        i++;
    }
}

int main(int argc, char *argv[])
{
    string dataset_path, classifier_path, fifo_path;
    split_by_space(argv[1], classifier_path, dataset_path, fifo_path);
    Classifier* classifier_instance;
    classifier_instance = new Classifier(classifier_path, dataset_path);
    classifier_instance->set_weights_and_data();
    int fifo_fd = open(fifo_path.c_str(), O_WRONLY | O_CREAT, 0666);
    close(fifo_fd);   
    mkfifo(fifo_path.c_str(), 0666);
    string result;
    result = classifier_instance->calculate();

    fifo_fd = open(fifo_path.c_str(), O_WRONLY | O_CREAT, 0666);
    write(fifo_fd, result.c_str(), result.size());
    close(fifo_fd);
}