// **************************************************************************
//  File       [main.cpp]
//  Author     [Ting-Yu]
//  Synopsis   [The main program handling Timeframe Expansion]
//  Modify     [2017/08/27 Ting-Yu Shen]
// **************************************************************************


#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include "../lib/tm_usage.h"
#include "Timeframe.h"
#include "ATPGModel.h"

using namespace std;

PCHBize readNetlist(string netlist){
	
	char buffer[200];
	char buffer2[200];
	fstream fin(netlist.c_str()); 					//Read netlist
	while(fin >> buffer){ 					//Drop useless information
		if(strcmp(buffer,"module")==0)
			break;
	}
	fin >> buffer; //Read module name
	PCHBize myPCHB(buffer);					//Intialize PCHB
	while(fin >> buffer){ 					//Read inputs and outputs
		if(strcmp(buffer,"input")==0){
			fin >> buffer;	//This is input name
			myPCHB.InsertInput(buffer);
			fin >> buffer;	//Useless
		}
		if(strcmp(buffer,"output")==0){
			fin >> buffer;	//This is output name
			myPCHB.InsertOutput(buffer);
			fin >> buffer;	//Useless
		}
		if(strcmp(buffer,"//startLogic")==0)//Important!! Remember to add mark into original bench
			break;
	}
	
	int gateType, gateID;
	string gateName; 
	char * cutter;
	while(fin >> buffer){					//Record Gate
		if(strcmp(buffer,"endmodule")==0)
			break;
		cutter=strchr(buffer,'_');
		if(cutter!=NULL){
			strncpy(buffer2, buffer, cutter-buffer); //Get GateType
			buffer2[cutter-buffer] = '\0';
			gateName = buffer2;
			for(int i = 1; i <= 19; i++){
				if(i == 19){
					cout << "Wrong gate type: " << gateName << endl;
					gateType = 19;
					break;
				}if(gateName.compare(myPCHB.catchGateType(i)) == 0){
					gateType = i;
					break;
				}
			}	
		}
		fin >> buffer;	//This is GateName
		gateID = myPCHB.InsertGate(buffer, gateType);
		//cout << "GateID/GateType/GateName = " << gateID << "/" << gateName << "/" << buffer << "/" << gateType << endl;
		fin >> buffer;	//Useless
		while(fin >> buffer) {				//Deal with IN/OUT
			if(strcmp(buffer,");")==0)
				break;
			cutter = strtok(buffer," .(),");	//InputType
			gateType = myPCHB.catchINOUTType(cutter);
			/*cout << "PinType/INOUT/PinName = " << cutter << "/";
			if(gateType == 0)
				cout << "In/";
			else if(gateType == 1)
				cout << "Out/";
			else
				cout << "Unknown/0";*/
			cutter = strtok(NULL," .(),");	//InputName
			//cout << cutter << endl;
			myPCHB.updateINOUT(gateID, cutter, gateType);
		}
	}
	return myPCHB;
}

void help_message() {
    cout << "usage: TimeframeExpansion <Usage>" << endl;
	cout << "Usage1:Dualize			   1 <InputFileName>	<OutputFileName>" << endl;
	cout << "Usage2:Expansion		   2 <SAF/TDF> <Timeframe_Number> <Enlargement> <MODEL_BASE> <STF_Model> <STR_Model> <library>" << endl;
	cout << "Usage3:ModNetlist		   3 <SI/NOSI> <SAF/TDF> <Timeframe_Number> <Enlargement> <OrignialFile> <STF_net> <STR_net> <STF_FL> <STR_FL>" << endl;
	cout << "Usage4:DepthCalculate	   4 <OrignialFile>" << endl;
	cout << "Usage5:Fault Count        5 <OrignialFile>" << endl;
	
	
}

int main(int argc, char* argv[])
{
    if(argc <= 2) {
       help_message();
       return 0;
    }
    CommonNs::TmUsage tmusg;
    CommonNs::TmStat stat;
	char buffer[200];
	char buffer2[200];
	int usage = atoi(argv[1]);
	fstream fout1;
    fstream fout2;
	fstream fout3;
	//////////// Mode: PCHB dualization //////////
	if(usage == 1){
		if(argc != 4) {
			cout << "Input/Output File not defined" << endl;
			return 0;
		}
		fstream fin(argv[2]); 					//Read netlist
		while(fin >> buffer){ 					//Drop useless information
			if(strcmp(buffer,"module")==0)
				break;
		}
		fin >> buffer; //Read module name
		PCHBize myPCHB(buffer);					//Intialize PCHB
		while(fin >> buffer){ 					//Read inputs and outputs
			if(strcmp(buffer,"input")==0){
				fin >> buffer;	//This is input name
				myPCHB.InsertInput(buffer);
				fin >> buffer;	//Useless
			}
			if(strcmp(buffer,"output")==0){
				fin >> buffer;	//This is output name
				myPCHB.InsertOutput(buffer);
				fin >> buffer;	//Useless
			}
			if(strcmp(buffer,"//startLogic")==0)//Important!! Remember to add mark into original bench
				break;
		}
		
		int gateType, gateID;
		string gateName; 
		char * cutter;
		while(fin >> buffer){					//Record Gate
			if(strcmp(buffer,"endmodule")==0)
				break;
			cutter=strchr(buffer,'_');
			if(cutter!=NULL){
				strncpy(buffer2, buffer, cutter-buffer); //Get GateType
				buffer2[cutter-buffer] = '\0';
				gateName = buffer2;
				for(int i = 1; i <= 19; i++){
					if(i == 19){
						cout << "Wrong gate type: " << gateName << endl;
						gateType = 19;
						break;
					}if(gateName.compare(myPCHB.catchGateType(i)) == 0){
						gateType = i;
						break;
					}
				}	
			}
			fin >> buffer;	//This is GateName
			gateID = myPCHB.InsertGate(buffer, gateType);
			//cout << "GateID/GateType/GateName = " << gateID << "/" << gateName << "/" << buffer << "/" << gateType << endl;
			fin >> buffer;	//Useless
			while(fin >> buffer) {				//Deal with IN/OUT
				if(strcmp(buffer,");")==0)
					break;
				cutter = strtok(buffer," .(),");	//InputType
				gateType = myPCHB.catchINOUTType(cutter);
				/*cout << "PinType/INOUT/PinName = " << cutter << "/";
				if(gateType == 0)
					cout << "In/";
				else if(gateType == 1)
					cout << "Out/";
				else
					cout << "Unknown/0";*/
				cutter = strtok(NULL," .(),");	//InputName
				//cout << cutter << endl;
				myPCHB.updateINOUT(gateID, cutter, gateType);
			}
		}
		myPCHB.printModNetlist(argv[3]);
	}	
	
	//////////// Mode: Timeframe Generation //////
	if(usage == 2){
		if(argc != 9) {
			help_message();
			return 0;
		}
			
		int TF = atoi(argv[3]);
		ModelFormatAnalyzer myanalyzer(0,TF);
		myanalyzer.readModelBase(argv[5]);
		
		if(strcmp(argv[2],"SAF")==0){
			myanalyzer.printSAFDelayModel(1,argv[6]);	//SA1
			myanalyzer.printSAFDelayModel(0,argv[7]);	//SA0
			myanalyzer.printSAFTimeframeModel(argv[8]);
		}else if(strcmp(argv[2],"TDF")==0) {
			myanalyzer.printTDFDelayModel(1,atoi(argv[4]),argv[6]);	//STF
			myanalyzer.printTDFDelayModel(0,atoi(argv[4]),argv[7]);	//STR
			myanalyzer.printTDFTimeframeModel(argv[8]);
		}else{
			cout << "Please choose SAF or TDF." << endl; 
			return 0;
		}
	}

	//////////// Mode: Timeframe Generation //////
	if(usage == 3){
		if(argc != 11) {
			help_message();
			return 0;
		}
		int SI = 0;
		if(strcmp(argv[2],"SI")==0)
			SI = 1;
		int TF = atoi(argv[4]);
		int enL = atoi(argv[5]);
		
		PCHBize myPCHB = readNetlist(argv[6]);
		
		myPCHB.insertDfT();
		myPCHB.removeExtraINV();
		if(strcmp(argv[3],"SAF")==0){
			myPCHB.printATPGModel(0,0,TF,enL,SI,argv[7],argv[9]);
			myPCHB.printATPGModel(1,0,TF,enL,SI,argv[8],argv[10]);
		}else if(strcmp(argv[3],"TDF")==0) {
			myPCHB.printATPGModel(0,1,TF,enL,SI,argv[7],argv[9]);
			myPCHB.printATPGModel(1,1,TF,enL,SI,argv[8],argv[10]);
		}else{
			cout << "Please choose SAF or TDF." << endl; 
			return 0;
		}

	}
	
	//////////// Mode: Calculate Dpeth //////
	if(usage == 4){
		if(argc != 3) {
			help_message();
			return 0;
		}
		
		PCHBize myPCHB = readNetlist(argv[2]);
		myPCHB.insertDfT();
		myPCHB.removeExtraINV();
		cout << "Depth: " << myPCHB.calculateDepth() << endl;
		
	}

	//////////// Mode: Fault //////
	if(usage == 5){
		if(argc != 3) {
			help_message();
			return 0;
		}
		
		PCHBize myPCHB = readNetlist(argv[2]);
		myPCHB.insertDfT();
		myPCHB.removeExtraINV();
		myPCHB.countfault();
		//cout << "Depth: " << myPCHB.calculateDepth() << endl;
		
	}
		
	
	///////////// Usage Calculation ////////////////
	tmusg.getPeriodUsage(stat);
    cout <<"# run time = " << (stat.uTime + stat.sTime) / 1000.0 << "ms" << endl;
    cout <<"# memory =" << stat.vmPeak / 1000.0 << "MB" << endl;

	
    return 0;
}


