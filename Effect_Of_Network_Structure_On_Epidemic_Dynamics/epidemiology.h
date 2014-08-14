/*
 * epidemiology.h
 *
 *  Created on: April 20, 2011
 *      Author: Aemen Lodhi
 *      Email: ##firstname.lastname##at#gatech.edu
 */

#ifndef EPIDEMIOLOGY_H_
#define EPIDEMIOLOGY_H_

#define DEBUG 0

#include<list>
#include<iostream>
#include<algorithm>
#include<cmath>
#include<math.h>
#include<stdlib.h>
#include<time.h>
#include<string>
#include<fstream>
#include<stdio.h>

using namespace std;

int activeNodes=0;
double totalSimTime=50;

bool isPresentInList(list<int> &,int);
void createRegularNetwork(int);
void createRandomNetwork(int);
void createScaleFreeNetwork(int);
void createSmallWorldNetwork(int,double);
void collectStatistics(int);
void printLog();

enum State{

	S,
	I,
	R

};

class Node{

public:
	int id;
	State nodeState;
	State nextState;
	list<int> contacts;	//nodes with which this node has contact
	double infectionProbability;	//defined [0,9]

	//timers
	int tI;
	int tR;

	int infectedTime;
	int susceptibleTime;
	int recoveredTime;


	//node statistics
	int timesInfected;
	int timesRecovered;
	int totalInfectionTime;
	int totalSusceptibleTime;
	list<int> infectionIntervals;
	list<int> susceptibleIntervals;
	list<int> recoveredIntervals;
	void (Node::*modelPointer)();

	Node();

	void selectModel(int);
	void updateStateSIR();
	void updateStateSIS();
	void updateStateSIRS();
	void updateState();
	void commitState();

};

Node* aliveNodes;

Node::Node(){

	id=-1;
	nodeState=S;
	infectionProbability=0;

	tI=tR=0;

	infectedTime=susceptibleTime=recoveredTime=0;

	timesInfected=timesRecovered=totalInfectionTime=totalSusceptibleTime=0;

}

void Node::selectModel(int modelNumber){

	if(modelNumber==0)
		modelPointer=&Node::updateStateSIR;

	if(modelNumber==1)
		modelPointer=&Node::updateStateSIS;

	if(modelNumber==2)
		modelPointer=&Node::updateStateSIRS;

}

void Node::updateState(){

	(this->*modelPointer)();

}

void Node::commitState(){
	nodeState=nextState;
}

void Node::updateStateSIR(){

	if(nodeState==I){	//if node is already sick

		infectedTime++;

		if(infectedTime>=tI){	//time to get well

			infectionIntervals.push_back(infectedTime);
			infectedTime=0;
			nextState=R;
			timesRecovered++;
		}

		else{
			nextState=I;
			totalInfectionTime++;
		}

	}//end if for sick

	else if(nodeState==R){	//node has recovered
		nextState=R;
		//do nothing
	}

	else{	//tricky node is susceptible

		list<int>::iterator itInt;
		for(itInt=contacts.begin();itInt!=contacts.end();itInt++){
			if(aliveNodes[*itInt].nodeState==I){	//contact is sick
				if((rand()%10)<infectionProbability){

					nextState=I;	//node got sick
					timesInfected++;
					susceptibleIntervals.push_back(susceptibleTime);
#if DEBUG
					cout<<"Node "<<id<<" got sick from "<<*itInt<<endl;
#endif
					break;

				}
			}
		}//end for

		if(nextState==S){	//node did not get infected

			nextState=S;
			susceptibleTime++;
			totalSusceptibleTime++;
		}

	}

}

void Node::updateStateSIS(){

	if(nodeState==I){	//if node is already sick

		infectedTime++;

		if(infectedTime>=tI){	//time to get susceptible again

			infectionIntervals.push_back(infectedTime);
			infectedTime=0;
			nextState=S;
			timesRecovered++;
		}

		else{
			nextState=I;
			totalInfectionTime++;
		}

	}//end if for sick

	else{	//tricky node is susceptible

		list<int>::iterator itInt;
		for(itInt=contacts.begin();itInt!=contacts.end();itInt++){
			if(aliveNodes[*itInt].nodeState==I){	//contact is sick
				if((rand()%10)<infectionProbability){

					nextState=I;	//node got sick
					timesInfected++;
					susceptibleIntervals.push_back(susceptibleTime);
#if DEBUG
					cout<<"Node "<<id<<" got sick from "<<*itInt<<endl;
#endif
					break;

				}
			}
		}//end for

		if(nextState==S){	//node did not get infected

			nextState=S;
			susceptibleTime++;
			totalSusceptibleTime++;
		}

	}

}

void Node::updateStateSIRS(){

	double infected=0;

	if(nodeState==I){	//if node is already sick

		infectedTime++;

		if(infectedTime>=tI){	//time to get well

			infectionIntervals.push_back(infectedTime);
			infectedTime=0;
			nextState=R;
			timesRecovered++;
		}

		else{
			nextState=I;
			totalInfectionTime++;
		}

	}//end if for sick

	else if(nodeState==R){

		recoveredTime++;

		if(recoveredTime>=tR){	//time to get susceptible again

			recoveredIntervals.push_back(recoveredTime);
			recoveredTime=0;
			nextState=S;

		}

		else{
			nextState=R;
		}

	}

	else{	//tricky node is susceptible

		list<int>::iterator itInt;
		for(itInt=contacts.begin();itInt!=contacts.end();itInt++){
			if(aliveNodes[*itInt].nodeState==I){	//contact is sick

				infected++;

			}
		}//end for

		if((static_cast<double>(rand()%10)/10)<infected/contacts.size()){
			nextState=I;	//node got sick
			timesInfected++;
			susceptibleIntervals.push_back(susceptibleTime);
		}


		if(nextState==S){	//node did not get infected

			nextState=S;
			susceptibleTime++;
			totalSusceptibleTime++;
		}

	}

}



void initialize(int modelNumber, int activeNodes, double infectionProbability, int initialInfections, int networkType, int degree, int infectionTime, int recoveredTime, double smallWorldRewireProbability){


	//modelNumber=0 SIR
	//modelNumber=1 SIS
	//modelNumber=2 SIRS

	//networkType=0 Regular

	int infectedNodes=0;
	int temp=0;

	aliveNodes=new Node[activeNodes];

	for(int i=0;i<activeNodes;i++){
		aliveNodes[i].id=i;
		aliveNodes[i].infectionProbability=infectionProbability;
		aliveNodes[i].tI=infectionTime;
		aliveNodes[i].tR=recoveredTime;
		aliveNodes[i].selectModel(modelNumber);

	}

	while(infectedNodes<initialInfections){

		temp=rand()%activeNodes;

		if(aliveNodes[temp].nodeState==S){
			aliveNodes[temp].nodeState=I;
			infectedNodes++;
		}

		else
			continue;


	}

	if(networkType==0)
		createRegularNetwork(degree);

	if(networkType==1)
		createRandomNetwork(degree);

	if(networkType==2)
		createScaleFreeNetwork(degree);

	if(networkType==3)
		createSmallWorldNetwork(degree,smallWorldRewireProbability);
}

void createSmallWorldNetwork(int degree, double smallWorldRewireProbability){

	int temp1=0;
	double temp2=0;
	int temp3=0;

	for(int i=0;i<activeNodes;i++){

		for(int j=1;j<=degree;j++){

			temp1=(i+j)%activeNodes;

			if(!isPresentInList(aliveNodes[i].contacts,temp1)){

				aliveNodes[i].contacts.push_back(temp1);
				aliveNodes[temp1].contacts.push_back(i);
			}

		}

	}


	for(int j=1;j<=degree;j++){
		for(int i=0;i<activeNodes;i++){

			temp1=(i+j)%activeNodes;
			if(isPresentInList(aliveNodes[i].contacts,temp1)){

				temp2=static_cast<double>(rand()%10)/10;

				if(temp2<smallWorldRewireProbability){

					do{

						temp3=rand()%activeNodes;

					}while(temp3==i || temp3==temp1 || isPresentInList(aliveNodes[i].contacts,temp3));

					aliveNodes[i].contacts.remove(temp1);
					aliveNodes[temp1].contacts.remove(i);

					aliveNodes[i].contacts.push_back(temp3);
					aliveNodes[temp3].contacts.push_back(i);

				}
			}
		}
	}

	//system check
	temp1=0;
	list<int>::iterator it;
	for(int i=0;i<activeNodes;i++){

		cout<<endl;
		cout<<i<<"\t";
		for(it=aliveNodes[i].contacts.begin();it!=aliveNodes[i].contacts.end();it++)
			cout<<*it<<"\t";

		if(aliveNodes[i].contacts.size()<1)
			temp1++;
	}

	cout<<endl<<temp1<<" nodes did not satisfy degree criteria for small world networks"<<endl;


}

void createScaleFreeNetwork(int degree){

	int temp1=0;
	int temp3=0;
	int temp4=0;
	double temp2=0;
	int sum=0;
	list<int> availableNets;
	list<int>::iterator it;

	for(int k=0;k<(degree+1);k++){
		aliveNodes[k].contacts.push_back(k+1);
		aliveNodes[k+1].contacts.push_back(k);

		if(!isPresentInList(availableNets,k))
			availableNets.push_back(k);

		if(!isPresentInList(availableNets,k+1))
			availableNets.push_back(k+1);

		sum+=2;
	}

	double probability=0;

	for(int i=degree+1;i<activeNodes;i++){

#if DEBUG
		cout<<"Finding provider for node "<<i<<endl;
#endif
		while(aliveNodes[i].contacts.size()<degree){

			temp3=rand()%availableNets.size();
			temp4=0;

#if DEBUG
		cout<<"temp3: "<<temp3<<endl;
#endif

			for(it=availableNets.begin();it!=availableNets.end();it++,temp4++)
				if(temp4==temp3){
					temp1=*it;

#if DEBUG
					cout<<"temp1: "<<temp1<<endl;
#endif

					break;
				}

			if(temp1!=i && !isPresentInList(aliveNodes[i].contacts,temp1) && aliveNodes[temp1].contacts.size()>0){

				probability=static_cast<double>(aliveNodes[temp1].contacts.size())/static_cast<double>(sum);
				temp2=static_cast<double>((rand()%10))/10;

#if DEBUG
				cout<<"probability: "<<probability<<endl;
				cout<<"temp2: "<<temp2<<endl;
#endif

				if(temp2<probability){

					aliveNodes[i].contacts.push_back(temp1);
					aliveNodes[temp1].contacts.push_back(i);
					sum+=2;
					availableNets.push_back(i);
				}

			}

		}

	}

	//system check
	temp1=0;
	for(int i=0;i<activeNodes;i++){

		cout<<endl;
		cout<<i<<"\t";
		for(it=aliveNodes[i].contacts.begin();it!=aliveNodes[i].contacts.end();it++)
			cout<<*it<<"\t";

		if(aliveNodes[i].contacts.size()<1)
			temp1++;
	}

	cout<<temp1<<" nodes did not satisfy degree criteria for scale free networks"<<endl;

}

void createRandomNetwork(int degree){

	int degreeUpperBound=3*degree;

	int temp1=0;
	int temp2=0;
	int temp3=0;

	for(int i=0;i<activeNodes;i++){

		temp2=0;
		temp3=rand()%(2*degree)+1;

		while(aliveNodes[i].contacts.size()<temp3 && temp2<(5*activeNodes)){

			temp1=rand()%activeNodes;

			if(temp1!=i && !isPresentInList(aliveNodes[i].contacts,temp1) && aliveNodes[temp1].contacts.size()<degreeUpperBound){

				aliveNodes[i].contacts.push_back(temp1);
				aliveNodes[temp1].contacts.push_back(i);
			}

			else{
				temp2++;
			}
		}

	}

	//system check
	temp1=0;
	list<int>::iterator it;
	for(int i=0;i<activeNodes;i++){

		cout<<endl;
		cout<<i<<"\t";
		for(it=aliveNodes[i].contacts.begin();it!=aliveNodes[i].contacts.end();it++)
			cout<<*it<<"\t";


		if(aliveNodes[i].contacts.size()<1)
			temp1++;
	}

	cout<<temp1<<" nodes did not satisfy degree criteria for random networks"<<endl;

}

void createRegularNetwork(int degree){

	int temp1=0;
	int temp2=0;
	for(int i=0;i<activeNodes;i++){

		temp2=0;

		while(aliveNodes[i].contacts.size()<degree && temp2<(5*activeNodes)){

			temp1=rand()%activeNodes;

			if(temp1!=i && !isPresentInList(aliveNodes[i].contacts,temp1) && aliveNodes[temp1].contacts.size()<degree){

				aliveNodes[i].contacts.push_back(temp1);
				aliveNodes[temp1].contacts.push_back(i);
			}

			else{
				temp2++;
			}
		}

	}

	//system check
	temp1=0;
	list<int>::iterator it;
	for(int i=0;i<activeNodes;i++){


		cout<<endl;
		cout<<i<<"\t";
		for(it=aliveNodes[i].contacts.begin();it!=aliveNodes[i].contacts.end();it++)
			cout<<*it<<"\t";


		if(aliveNodes[i].contacts.size()<degree)
			temp1++;
	}

	cout<<temp1<<" nodes did not satisfy degree criteria for regular networks"<<endl;
}

bool isPresentInList(list<int> &checkList,int toCheck){

	list<int>::iterator it;
	for(it=checkList.begin();it!=checkList.end();it++)
		if(*it==toCheck)
			return true;

	return false;

}


void collectStatistics(int time){


	ofstream populationStateFile;
	populationStateFile.open("popStateFile.txt",ios::out | ios::app);


	double s=0;
	double i=0;
	double r=0;

	for(int j=0;j<activeNodes;j++){
		if(aliveNodes[j].nodeState==S){
			s++;
		}
		else if(aliveNodes[j].nodeState==I){
			i++;
		}
		else{
			r++;
		}
	}


	populationStateFile<<time<<":"<<s/activeNodes<<":"<<i/activeNodes<<":"<<r/activeNodes<<endl;

	/*
	ofstream peakFile;
	peakFile.open("peakInfectionFraction.txt", ios::out | ios::app);
	static list<double> infectedFraction;
	infectedFraction.push_back(static_cast<double>(i)/activeNodes);

	if(time==(totalSimTime-1)){
		infectedFraction.sort();
		peakFile<<infectedFraction.back()<<endl;
	}


	ofstream persistenceFile;
	persistenceFile.open("persistence.txt",ios::out | ios::app);


	if(i==0 || time==totalSimTime){
		persistenceFile<<time<<endl;
		exit(0);
	}
	*/

}


#endif /* EPIDEMIOLOGY_H_ */
