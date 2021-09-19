#include "Monitor.h"
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <thread>
#include <stdlib.h>
#include <chrono>
#include <stdlib.h>
#include <time.h>

using namespace std::chrono;
using namespace std;

double totalEmission;
sem_t totalEmissionSem;

void readFromFile(string pathName, vector<vector<string>> &data, vector<vector<string>> &pathsInf) { 
	fstream fin;

	fin.open(pathName, ios::in);

    vector<string> row;
	string word, temp;
    bool pointFinished = false;

	while (fin >> temp) {
        if (temp[0] == '#') {
            pointFinished = true;
        }
        if (!pointFinished) {
            row.clear();
            stringstream s(temp);
            while (getline(s, word, '-')) {
                row.push_back(word);
            }
            data.push_back(row);
        } else {
            row.clear();
            stringstream s(temp);
            if (temp[0] != '#') {
                while (getline(s, word, '-')) {
                    row.push_back(word);
                }
                pathsInf.push_back(row);
            }
        }
	}
}

void setPoints(vector<vector<string>> points, vector<Point> &allPoints) {
    for (int i = 0; i < points.size(); i++) {
        Point p;
        p.source = points[i][0];
        p.destination = points[i][1];
        p.h = stoi(points[i][2]);
        allPoints.push_back(p);
    }
}

void setPaths(vector<vector<string>> pathsInf, vector<Path> &paths, vector<Point> allPoints) {
    for (int i = 0; i < pathsInf.size(); i+=2) {
        Path p;
        for (int k = 0; k < pathsInf[i].size(); k++) {
            for (int j = 0; j < allPoints.size(); j++) {
                if (pathsInf[i][k] == allPoints[j].source && pathsInf[i][k+1] == allPoints[j].destination) {
                    p.pathSequence.push_back(allPoints[j]);
                }
            }
        }
        paths.push_back(p);
    }
    int index = 0;
    for (int i = 1; i < pathsInf.size(); i+=2) {
        paths[index].numOfCarsInSource = stoi(pathsInf[i][0]);
        paths[index].id = index + 1;
        index++;
    }
}

void setCars(vector<Path> paths, vector<Car*> &cars) {
    int carNum = 1;
    for (int i = 0; i < paths.size(); i++) {
        for (int j = 0; j < paths[i].numOfCarsInSource; j++) {
            Car* car = new Car();
            car->carPath = paths[i];
            car->currentNode = paths[i].pathSequence[0];
            car->num = j + 1;
            car->p = rand() % 10 + 1;
            car->id = carNum;
            cars.push_back(car);
            carNum++;
        }
    }
}

Monitor* findMonitor(vector<Monitor*> monitors, Point po) {
    bool found = false;
    for (int i = 0; i < monitors.size(); i++) {
        if (monitors[i]->p.source == po.source && monitors[i]->p.destination == po.destination) {
            found = true;
            return monitors[i];
        }
    }
    if (!found) {
        return NULL;
    }
}

void CreateFile(Car* car) {
    ofstream carFile;
    carFile.open (to_string(car->carPath.id) + "-" + to_string(car->id), ios_base::app);
    stringstream s;
    s << car->begin;
    string begin = s.str();
    stringstream ss;
    ss << car->end;
    string end = ss.str();
    string in = car->currentNode.source + "," 
    + begin + ","
    + car->currentNode.destination + ","
    + end +","
    + to_string(car->emission) + ","
    + to_string(car->totalEmission) + "\n";
    carFile << in;
    carFile.close();
}

void moveInRoad(vector<Monitor*> monitors, Car* car) {
    for (int i = 0; i < car->carPath.pathSequence.size(); i++) {
        Monitor* mon = findMonitor(monitors, car->carPath.pathSequence[i]);
        mon->moveInPath(car);
        CreateFile(car);
    }
}

int main(int argc, char* argv[])
{
    srand (time(NULL));
    totalEmission = 0;
    sem_init(&totalEmissionSem, 0, 1);
    vector<vector<string>> points;
    vector<vector<string>> pathsInf;
    vector<Path> paths;
    readFromFile(argv[1], points, pathsInf);
    vector<Point> allPoints;
    vector<Car*> cars;
    setPoints(points, allPoints);
    setPaths(pathsInf, paths, allPoints);
    setCars(paths, cars);
    Monitor* monitor = new Monitor();
    vector <Monitor*> monitors;
    for (int i = 0; i < allPoints.size(); i++) {
        Monitor* mon = new Monitor(allPoints[i]);
        monitors.push_back(mon);
    }
    vector<thread> threads;
    for (int i = 0; i < cars.size(); i++) {
        thread t1(&moveInRoad, monitors, cars[i]);
        threads.push_back(move(t1));
    }
    for (int k = 0; k < threads.size(); k++) {
        threads[k].join();
    }
}