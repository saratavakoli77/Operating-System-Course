all: RoadMonitor
		make RoadMonitor
		make clean

RoadMonitor: main.o Monitor.o Condition.o
	g++ main.o Monitor.o Condition.o -lpthread -lrt -o RoadMonitor

Monitor.o: Monitor.cpp
	g++ -c Monitor.cpp

Condition.o: Condition.cpp
	g++ -c Condition.cpp

main.o: main.cpp 
	g++ -c main.cpp 

clean: 
	rm -f *.o 