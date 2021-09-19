all: EnsembleClassifier
		make EnsembleClassifier
		make classifier
		make voter
		make clean

EnsembleClassifier: main.o classifier.o ensemble.o
	g++ main.o classifier.o ensemble.o -o EnsembleClassifier.out

classifier: classifierMain.o classifier.o
	g++ classifierMain.o classifier.o -o classifier

classifierMain.o: classifierMain.cpp
	g++ -c classifierMain.cpp

voter.o: voterMain.cpp
	g++ -c voterMain.cpp -o voter.o

voter: voter.o
	g++ voter.o -o voter


main.o: main.cpp 
	g++ -c main.cpp 

classifier.o: classifier.cpp
	g++ -c classifier.cpp 

tools.o: tools.cpp
	g++ -c tools.cpp

ensemble.o: ensemble.cpp
	g++ -c ensemble.cpp

clean: 
	rm -f *.o 