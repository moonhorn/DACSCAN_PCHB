// **************************************************************************
//  File       [WorkerAnt.h]
//  Author     [Yu-Hao Ho]
//  Synopsis   [The header file of worker ant]
//  Modify     [2015/03/20 Yu-Hao Ho]
// **************************************************************************

#ifndef _TIMEFRAME_H
#define _TIMEFRAME_H

#include <list>
#include <vector>
#include <string>
using namespace std;

class PCHBgate {
	public:
					PCHBgate(string, int );	//Define gatetype and gatename
		inline void InsertInput(string name){InputName.push_back(name);}
		inline void InsertOutput(string name){OutputName.push_back(name);}
		inline int	readGateType(){ return gateType; }
		inline string	readGateName(){ return gateName; }
		inline string	readInputName(int i){ return InputName[i]; }
		inline string	readOutputName(int i){ return OutputName[i]; }
		inline void		modifyPI2PPO(int i){ InputName[i]+="_ppo"; }
		inline void		modifyPO2PPO(int i){ OutputName[i]+="_ppo"; }
		inline void		modifyPPI(int i){ InputName[i]+="_ppi"; }
		inline int	readInputLength(){ return InputName.size(); }
		inline int	readOutputLength(){ return OutputName.size(); }
		inline void updateDepth(int i){ depth = i; }
		inline int	readDepth(){ return depth; }
		inline void modifyPI(int i, string PI){ InputName[i] = PI; }
		
		//	Type 	NA = 0, INV, AND2, AND3, AND4,
		//			NAND2, NAND3, NAND4,
        //			OR2, OR3, OR4,
        //			NOR2, NOR3, NOR4,
        //			XOR2, XOR3, XNOR2, XNOR3, MUX
			
		
	private:
	
		string			gateName;
		int				gateType;
		int				depth;
		vector<string>	InputName;
		vector<string>	OutputName;
		
};



class PCHBize {
    public:
        
					PCHBize(string );		//constructor
		//void		printSTFmodel();
		//void		printSTRmodel();
		inline void InsertInput(string name){InputName.push_back(name);}
		inline void InsertOutput(string name){OutputName.push_back(name);}
		int			InsertGate(string , int );
		void		updateINOUT(int , string , int );
		string		catchGateType(int );
		int			catchINOUTType(string );
		inline string	CheckModuleName(){	return moduleName; }
		void		printModNetlist(string ); 
		void		printATPGModel(int , int , int , int , int , string , string );
		int			searchWireName(string );
		int			calculateDepth();
		void		insertDfT();
		void		removeExtraINV();
		
		
    private:
		
		string			moduleName;
		vector<string>	InputName;
		vector<string>	OutputName;
		vector<PCHBgate>	GateList;
		vector<string>	PPIName;
		vector<string>	PPOName;
		vector<string>	wireName;
		
};

/*
class FMnet {
	public:
	
		void		FMnet(int);
		bool		critical;
		
	private:
	
		int			netID;
		vector<int>	childCell;
};

const char* ToString(EValue value)
{
 switch (value)
 {
 case KZero:
  return "Zero";
 case KOne:
  return "One";
 case KTwo:
  return "Two";
 }
 return "Not Defined";
}
*/

#endif


