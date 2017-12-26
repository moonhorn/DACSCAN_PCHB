// **************************************************************************
//  File       [ATPGModel.h]
//  Author     [Ting-Yu Shen]
//  Synopsis   [The header file of delay model Generation]
//  Modify     [2017/09/27 Ting-Yu Shen]
// **************************************************************************

#ifndef _ATPGMODEL_H
#define _ATPGMODEL_H

#include <list>
#include <vector>
#include <string>
using namespace std;

class ModelGate	{
	public:
					ModelGate(string , int );
		int			InsertLogic(string );
		void		InsertSublogic(int , string );
		string		readSublogic(int , int );
		inline int 	readsizelogic() { return logic.size(); }
		inline int 	readsizeSublogic(int ID) { return logic[ID].size(); }
		inline int	readFanin() {return fanin; }
		inline string readName() {return name; }
		
		
	private:
		string		name;	
		int 		fanin;
		vector<vector<string> > logic;	

};


class ModelFormatAnalyzer {
	public:
					ModelFormatAnalyzer(int , int );
		void		readModelBase(string );
		int 		InsertGate(string , int );
		void		printSAFDelayModel(int , string);	// 0-SA0 1-SA1
		void		printTDFDelayModel(int , int , string);	// 0-STR 1-STF
		void		printSAFTimeframeModel(string );
		void		printTDFTimeframeModel(string );
		
	
	private:
		int			timeframe;
		int			faultType; 		//0 = SAF, 1 = TDF
		vector<ModelGate>	GateList;
		
		
};


#endif
