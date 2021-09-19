#include "ensemble.h"

Ensemble::Ensemble(string _validation_path, string wait_vectors_path, int classifiers_number) {
    classifier_number = classifiers_number;
    validation_path = _validation_path;
    dataset_path = _validation_path + "/dataset.csv";
    weights_path = wait_vectors_path + "/classifier_";
}

string Ensemble::create_classifiers_name(int i) {
    string data;
    data = weights_path + to_string(i) + ".csv";
    return data;
}

void Ensemble::create_classifiers() {
    int p[classifier_number][2];
    for (int i = 0; i < classifier_number; i++) {
        if (pipe(p[i]) == -1) {
            perror("pipe() failed!");
            exit(1);
        }
        int pid = fork();
        if (pid == 0) {
            close(p[i][1]);
            char msg[1500];
            read(p[i][0], msg, 1500);
            close(p[i][0]);
            char* argv[3] = {"classifier", msg, NULL};
            execv("./classifier", argv);
        } else if(pid > 0) {
            close(p[i][0]);
            string files_name;
            string data;
            data = create_classifiers_name(i);
            data = data + "-" + dataset_path + "-" + "fifo" + to_string(i) + ".csv" + "\0";
            write(p[i][1], data.c_str(), (data.length())+1);
            close(p[i][1]);
        }
    }
    for (int i = 0; i < classifier_number; i++) {
        wait(NULL);
    }
    int pi[2];
    if (pipe(pi) == -1) {
        perror("pipe() failed!");
        exit(1);
    }
    int voter_pid = fork();
    if (voter_pid == 0) {
        close(pi[1]);
        char msg[1500];
        read(pi[0], msg, 1500);
        close(pi[0]);
        char* argv[3] = {"voter", msg, NULL};
        execv("./voter", argv);
    } else if (voter_pid > 0) {
        close(pi[0]);
        string fifo_dir = "fifo-" + to_string(classifier_number) + "-" + validation_path + "\0";
        write(pi[1], fifo_dir.c_str(), (fifo_dir.length())+1);
        close(pi[1]);
    }
}

