#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <map>
#include <iterator>

using namespace std;

void separate_by_dash(string word, string &fifo_path, int &classifier_num, string &validaion_path) {
    int i = 0;
    while(word[i] != '-') {
        fifo_path = fifo_path + word[i];
        i++;
    }
    i++;
    string num;
    while (word[i] != '-') {
        num = num + word[i];
        i++;
    }
    classifier_num = stoi(num);
    i++;
    while(word[i] != '\0'){
        validaion_path = validaion_path + word[i];
        i++;
    }   
}

void read_from_csv(string addr, vector<int> &numbers) {
    ifstream fd;
    string temp;
    int label;
    fd.open(addr);
    while (fd >> label) 
        numbers.push_back(label);
    fd.close();
}

void read_lable(string addr, vector<int> &numbers) {
    ifstream fd;
    string temp;
    string tmp;
    int label;
    fd.open(addr);
    getline(fd, tmp);
    while (fd >> label) {
        numbers.push_back(label);
    }
    fd.close();
}

void calculate_max(vector<vector<int>> numbers, vector<int> &result) {
    for (int i = 0; i < numbers[0].size(); i++) {
        map<int, int> values;
        map<int, int>::iterator iter;
        for (int j = 0; j < numbers.size(); j++) {
            values[numbers[j][i]]++;
        }
        int max = 0;
        int val;
        for (iter = values.begin(); iter != values.end(); iter++) {
            if (iter->second > max) {
                max = iter->second;
                val = iter->first;
            }
        }
        result.push_back(val);
    }
}

float calculate_accuracy(vector<int> labels, vector<int> result) {
    float accuracy = 0;
    for (int i = 0; i <= labels.size(); i++) {
        if (labels[i] == result[i]) {
            accuracy++;
        }
    }
    return (accuracy/labels.size())*100;
}

int main(int argc, char *argv[]) 
{
    string fifo_dir;
    int classifiers_num;
    string validation_path;
    separate_by_dash(argv[1], fifo_dir, classifiers_num, validation_path);
    vector<vector<int>> all_classifiers_data;
    vector<int> result;
    for (int i = 0; i < classifiers_num; i++) {
        string fifo_path;
        vector<int> temp;
        fifo_path = fifo_dir + to_string(i) + ".csv";
        read_from_csv(fifo_path, temp);
        all_classifiers_data.push_back(temp);
    }
    calculate_max(all_classifiers_data, result);
    vector<int> labels;
    validation_path = validation_path + "/labels.csv";
    read_lable(validation_path, labels);
    cout << "accuracy is " << calculate_accuracy(labels, result) << "%" << endl;
}