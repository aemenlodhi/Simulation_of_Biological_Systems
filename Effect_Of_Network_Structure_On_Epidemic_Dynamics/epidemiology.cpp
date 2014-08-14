/*
 * epidemiology.cpp
 *
 *  Created on: April 20, 2011
 *      Author: Aemen
 */

#include "epidemiology.h"

int main(int argc, char** argv){

	if(argc!=4){
		cout<<"Usage: Avg.Degree NetworkType InfectionProbability"<<endl;
		exit(-1);
	}

	int modelNumber=2;
	activeNodes=10000;
	double infectionProbability=atof(argv[3]);
	int initialInfections=1000;
	int networkType=atoi(argv[2]);
	int degree=atoi(argv[1]);
	int infectionTime=4;
	int recoveredTime=9;
	double smallWorldRewireProbability=0.9;
	totalSimTime=5600;
	srand(time(NULL));

	initialize(modelNumber, activeNodes, infectionProbability, initialInfections, networkType, degree, infectionTime, recoveredTime, smallWorldRewireProbability);


	for(int t=0;t<totalSimTime;t++){

		for(int i=0;i<activeNodes;i++){
			aliveNodes[i].updateState();

#if DEBUG
			cout<<"Node "<<i<<" is in state "<<aliveNodes[i].nodeState<<endl;
#endif
		}

		if(t>5000)
			collectStatistics(t);

		for(int i=0;i<activeNodes;i++){
			aliveNodes[i].commitState();
		}



	}


	return 0;
}
