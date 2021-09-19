#include "classifier.h"

using namespace std;

Classifier::Classifier(string _weights_path_name, string _input_data_path_name) {
    weights_path_name = _weights_path_name;
	input_data_path_name = _input_data_path_name;
}

void read_from_csv(string path_name,vector<vector<double>> &data) 
{ 
	fstream fin;

	fin.open(path_name, ios::in);

	vector<double> row;
	string word, temp;

	fin >> temp;
	while (fin >> temp) {
		row.clear();
		stringstream s(temp);
		while (getline(s, word, ',')) {
			row.push_back(stod(word));
		}
        data.push_back(row);
	}
}

void Classifier::set_weights_and_data() {
    read_from_csv(weights_path_name, weights);
	read_from_csv(input_data_path_name, input_data);
}

string Classifier::calculate() {
    int index;
    string result = "";
    double score, max;
    for (int i = 0; i < input_data.size(); i++) {
        max = INT_LEAST32_MIN;
        for (int j = 0; j < weights.size(); j++) {
            score = input_data[i][0] * weights[j][0] + input_data[i][1] * weights[j][1] + weights[j][2];
            if (score > max) {
                max = score;
                index = j;
            }
        }
        result += to_string(index) + "\n";
    }
    return result;
}