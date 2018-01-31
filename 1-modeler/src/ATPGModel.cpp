// **************************************************************************
//  File       [ATPGModel.cpp]
//  Author     [Yu-Hao Ho]
//  Synopsis   [The implementation of worker ant function]
//  Modify     [2015/03/20 Yu-Hao Ho]
// **************************************************************************

#include "ATPGModel.h"
#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

// Constructor
ModelFormatAnalyzer::ModelFormatAnalyzer(int FT , int TF) {
		timeframe = TF;
		faultType = FT;
}

int ModelFormatAnalyzer::InsertGate(string name, int fanin ) {
	GateList.push_back(ModelGate(name, fanin));
	return GateList.size();
}

void ModelFormatAnalyzer::readModelBase(string filename) {
	string gateName;
	int logiclistID, gatelistID;
	char buffer[200];
	fstream fin(filename.c_str()); 				//Read model base
	while(fin >> buffer){ 					//Drop useless information
		if(strcmp(buffer,"//Model")==0)
			break;
	}
	while(fin >> buffer){
		if(strcmp(buffer,";")!=0){
			gateName = buffer;
			fin >> buffer;
			gatelistID = InsertGate(gateName, atoi(buffer));
			while(fin >> buffer){
				if(strcmp(buffer,";")!=0){
					logiclistID = GateList[gatelistID-1].InsertLogic(buffer);
					while(fin >> buffer){
						if(strcmp(buffer,";")!=0){
							GateList[gatelistID-1].InsertSublogic(logiclistID, buffer);
						}else
							break;
					}
				}else
					break;
			}
		}else
			break;
	}
}

void ModelFormatAnalyzer::printSAFDelayModel(int type, string filename) {	//0-SA0 1-SA1
	
	fstream fout1;
	fout1.open(filename.c_str(), ios::out);
	fout1 << "module STUCKAT_FAULT_MODEL ( ";
	for(int k = 1; k <= timeframe; k++){
		fout1 << "TF" << k << ", ";
	}
	for(int k = 1; k <= timeframe; k++){
		fout1 << "ZN" << k << ", ";
	}
	fout1 << "TIE_VALUE );" << endl;
	fout1 << endl;
	for(int k = 1; k <= timeframe; k++){
		fout1 << "	input TF" << k << ";" << endl;
	}
	for(int k = 1; k <= timeframe; k++){
		fout1 << "	output ZN" << k << ";" << endl;
	}
	fout1 << "    input TIE_VALUE;" << endl;
	fout1 << endl;
	if( type == 0 )
			fout1 << "    assign TIE_VALUE = 1'b1;" << endl;
	else
			fout1 << "    assign TIE_VALUE = 1'b0;" << endl;
	fout1 << endl;
	fout1 << "    BUF_X1 buffer( .Z(TieModel), .A(TIE_VALUE) );" << endl;
	
	for(int k = 1; k <= timeframe; k++){
		if(type == 0)
			fout1 << "	AND2_X1 g";
		else
			fout1 << "	OR2_X1 g";
		fout1 << k << " ( .ZN(ZN" << k << "), .A1(TieModel), .A2(TF" << k << ") );" << endl;
	}
	fout1 << endl;
	fout1 << "endmodule" << endl; 
	fout1.close();
}

void ModelFormatAnalyzer::printTDFDelayModel(int type, int step, string filename) {	//0-STR 1-STF
	
	fstream fout1;
	fout1.open(filename.c_str(), ios::out);
	fout1 << "module DELAY_FAULT_MODEL ( ";
	for(int k = 1; k <= timeframe; k++){
		fout1 << "TF" << k << ", ";
	}
	for(int k = 1; k < timeframe; k++){
		fout1 << "ZN" << k << ", ";
	}
	fout1 << "TIE_VALUE );" << endl;
	fout1 << endl;
	for(int k = 1; k <= timeframe; k++){
		fout1 << "	input TF" << k << ";" << endl;
	}
	for(int k = 1; k < timeframe; k++){
		fout1 << "	output ZN" << k << ";" << endl;
	}
	fout1 << "    input TIE_VALUE;" << endl;
	fout1 << endl;
	if( type == 0 )
			fout1 << "    assign TIE_VALUE = 1'b1;" << endl;
	else
			fout1 << "    assign TIE_VALUE = 1'b0;" << endl;
	fout1 << endl;
	fout1 << "    BUF_X1 buffer( .Z(TieModel), .A(TIE_VALUE) );" << endl;
	int i = 0;	
	for(int k = 1; k < step-1; k++){
		for(int l = 1; l < k; l++){
			if(type == 0)
				fout1 << "	AND2_X1 g";
			else
				fout1 << "	OR2_X1 g";
			if(l == 1)
				fout1 << i << "_" << l << " ( .ZN(ModelOutput" << k << "_" << l << "), .A1(TF" << k-step+l+2 << "), .A2(TF" << k-step+l+3 << ") );" << endl;
			else
				fout1 << i << "_" << l << " ( .ZN(ModelOutput" << k << "_" << l << "), .A1(ModelOutput" << k << "_" << l-1 << "), .A2(TF" << k-step+l+1 << ") );" << endl;
		}
		if(type == 0)
			fout1 << "	OR2_X1 g";
		else
			fout1 << "	AND2_X1 g";
		if(k == 1)
			fout1 << i << " ( .ZN(ModelOutput" << k << "), .A1(TieModel), .A2(TF1) );" << endl;
		else
			fout1 << i << " ( .ZN(ModelOutput" << k << "), .A1(TieModel), .A2(ModelOutput" << k << "_" << k-1 << ") );" << endl;
		i++;
		if(type == 0)
			fout1 << "	AND2_X1 g";
		else
			fout1 << "	OR2_X1 g";
		fout1 << i << " ( .ZN(ZN" << k << "), .A1(ModelOutput" << k << "), .A2(TF" << k+1 << ") );" << endl;
		i++;
	}
	for(int k = step-1 ; k < timeframe; k++){
		for(int l = 1; l < step-1; l++){
			if(type == 0)
				fout1 << "	AND2_X1 g";
			else
				fout1 << "	OR2_X1 g";
			if(l == 1)
				fout1 << i << "_" << l << " ( .ZN(ModelOutput" << k << "_" << l << "), .A1(TF" << k-step+l+1 << "), .A2(TF" << k-step+l+2 << ") );" << endl;
			else
				fout1 << i << "_" << l << " ( .ZN(ModelOutput" << k << "_" << l << "), .A1(ModelOutput" << k << "_" << l-1 << "), .A2(TF" << k-step+l+2 << ") );" << endl;
		}
		if(type == 0)
			fout1 << "	OR2_X1 g";
		else
			fout1 << "	AND2_X1 g";
		if(k == 1)
			fout1 << i << " ( .ZN(ModelOutput" << k << "), .A1(TieModel), .A2(ModelOutput" << k << ") );" << endl;
		else
			fout1 << i << " ( .ZN(ModelOutput" << k << "), .A1(TieModel), .A2(ModelOutput" << k << "_" << step-2 << ") );" << endl;
		i++;
		if(type == 0)
			fout1 << "	AND2_X1 g";
		else
			fout1 << "	OR2_X1 g";
		fout1 << i << " ( .ZN(ZN" << k << "), .A1(ModelOutput" << k << "), .A2(TF" << k+1 << ") );" << endl;
		i++;
	}
	fout1 << endl;
	fout1 << "endmodule" << endl; 
	fout1.close();
}

void ModelFormatAnalyzer::printSAFTimeframeModel(string filename) {
	int temp;
	fstream fout;
	fout.open(filename.c_str(), ios::out);
	fout << "//Generated by LaDS PCHB Generator" << endl;
	
	/////// Idiot Implement method, require rewrite//////
	fout << "module CEMT2 (A1, A2, ZN, PI);" << endl;
	fout << "  input A1;" << endl;
	fout << "  input A2;" << endl;
	fout << "  input PI;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl;
	fout << "  AND2_X1 U1(.ZN(i_1), .A1(A1), .A2(A2));" << endl;
	fout << "  AND2_X1 U2(.ZN(i_2), .A1(A1), .A2(PI));" << endl;
	fout << "  AND2_X1 U3(.ZN(i_3), .A1(PI), .A2(A2));" << endl;
	fout << "  OR3_X1 U4(.ZN(ZN), .A1(i_1), .A2(i_2), .A3(i_3));" << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module CEMT3 (A1, A2, A3, ZN, PI);" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input A2;" << endl;
	fout << "  input A3;" << endl;
	fout << "  input PI;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl;
	fout << "  AND3_X1 U1(.ZN(i_1), .A1(A1), .A2(A2), .A3(A3));" << endl;
	fout << "  OR3_X1 U2(.ZN(i_2), .A1(A1), .A2(A2), .A3(A3));" << endl;
	fout << "  AND2_X1 U3(.ZN(i_3), .A1(PI), .A2(i_2));" << endl;
	fout << "  OR2_X1 U4(.ZN(ZN), .A1(i_1), .A2(i_3)); " << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module CEMT4 (A1, A2, A3, A4, ZN, PI);" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input A2;" << endl;
	fout << "  input A3;" << endl;
	fout << "  input A4;" << endl;
	fout << "  input PI;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl;
	fout << "  AND4_X1 U1(.ZN(i_1), .A1(A1), .A2(A2), .A3(A3), .A4(A4));" << endl;
	fout << "  OR4_X1 U2(.ZN(i_2), .A1(A1), .A2(A2), .A3(A3), .A4(A4));" << endl;
	fout << "  AND2_X1 U3(.ZN(i_3), .A1(PI), .A2(i_2));" << endl;
	fout << "  OR2_X1 U4(.ZN(ZN), .A1(i_1), .A2(i_3)); " << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module TSB (A1, EN, ZN, Empty); // Tristate Buffer" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input EN;" << endl;
	fout << "  input Empty;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl; 
	fout << "  AND2_X1 U1(.ZN(W1), .A1(A1), .A2(EN));" << endl;
	fout << "  AND2_X1 U2(.ZN(W2), .A1(Empty), .A2(~EN));" << endl;
	fout << "  OR2_X1 U3(.ZN(ZN), .A1(W1), .A2(W2)); " << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module RTSB (A1, EN, ZN, Empty); // Reverse Tristate Buffer" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input EN;" << endl;
	fout << "  input Empty;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl;  
	fout << "  AND2_X1 U1(.ZN(W1), .A1(A1), .A2(~EN));" << endl;
	fout << "  AND2_X1 U2(.ZN(W2), .A1(Empty), .A2(EN));" << endl;
	fout << "  OR2_X1 U3(.ZN(ZN), .A1(W1), .A2(W2)); " << endl;
	fout << endl; 
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module CD (A1, A2, ZN); // Completion Detector" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input A2;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl; 
	fout << "  OR2_X1 U1(.ZN(ZN), .A1(A1), .A2(A2));" << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module ATPG_control (enP, pcP, enN, pcN, Empty, PI, PPI, ZN);" << endl;
	fout << endl;
	fout << "  input enP, enN;" << endl;
	fout << "  input pcP, pcN;" << endl;
	fout << "  input Empty;" << endl;
	fout << "  input PI;" << endl;
	fout << "  input PPI;" << endl;
	fout << endl;
	fout << "  output ZN;" << endl;
	fout << endl;
	fout << "  AND2_X1 U1(.A1(~enP), .A2(~pcP), .ZN(W1));" << endl;
	fout << "  AND2_X1 U2(.A1(enN), .A2(pcN), .ZN(W2));" << endl;
	fout << "  AND3_X1 U3(.ZN(W3), .A1(~W1), .A2(~W2), .A3(PPI));	//Hold" << endl;
	fout << "  AND3_X1 U4(.ZN(W4), .A1(~W1), .A2(W2), .A3(PI));		//Evaluate" << endl;
	fout << "  AND3_X1 U5(.ZN(W5), .A1(W1), .A2(~W2), .A3(Empty));	//Precharge" << endl;
	fout << "  AND3_X1 U6(.ZN(W6), .A1(W1), .A2(W2), .A3(~Empty));	//High Impedence" << endl;
	fout << "  OR4_X1 U7(.ZN(ZN), .A1(W3), .A2(W4), .A3(W5), .A4(W6));" << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	/////// End //////
	
	//Implement Inverter
	fout << "module INV_PCHB_MODEL(";
	for(int i = 1; i <= timeframe; i++){
		fout << "A1_f_TF" << i << ", A1_t_TF" << i << ", ";
		if(i != timeframe)
			fout << "ZN_f_TF" << i << ", ZN_t_TF" << i << ", ";
		else
			fout << "ZN_f_TF" << i << ", ZN_t_TF" << i << ");" << endl;
	}
	fout << endl;
	for(int i = 1; i <= timeframe; i++){
		fout << "	input A1_f_TF" << i << ", A1_t_TF" << i << ";" << endl;
	}
	for(int i = 1; i <= timeframe; i++){
		fout << "	output ZN_f_TF" << i << ", ZN_t_TF" << i << ";" << endl;
	}
	fout << endl;
	for(int i = 1; i <= timeframe; i++){
		fout << "	assign ZN_f_TF" << i << " = A1_t_TF" << i << ";" << endl; 
		fout << "	assign ZN_t_TF" << i << " = A1_f_TF" << i << ";" << endl;
	}
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	
	//Implement Logic Gate
	for(int j = 0; j < GateList.size(); j++){
		fout << "module " << GateList[j].readName() << "_PCHB_STUCKAT_MODEL(";
		for(int i = 1; i <= timeframe; i++){
			fout << "AckR_TF" << i << ", AckL_TF" << i << ", ";
			for(int k = 1; k <= GateList[j].readFanin(); k++){
				fout << "A" << k << "_f_TF" << i << ", A" << k << "_t_TF" << i << ", ";
			}
			fout << "ZN_f_TF" << i << ", ZN_t_TF" << i << ", reset_TF" << i << ", ";
		}
		fout << "PPI_t, PPI_f, PPI_c, Empty, TIE_VALUE);" << endl;
		fout << endl;
		// I/O List 
		for(int i = 1; i <= timeframe; i++){
			fout << "input AckR_TF" << i << ", ";
			for(int k = 1; k <= GateList[j].readFanin(); k++){
				fout << "A" << k << "_f_TF" << i << ", A" << k << "_t_TF" << i << ", ";
			}
			fout << "reset_TF" << i << ";" << endl;
			fout << "output ZN_f_TF" << i << ", ZN_t_TF" << i << ", AckL_TF" << i << ";" << endl;
			
		}
		fout << "input PPI_t, PPI_f, PPI_c, Empty, TIE_VALUE;" << endl;
		fout << endl;

		//SA fault model
		temp = 1;
		fout << "//On-logic fault" << endl;
		for(int k = 1; k <= GateList[j].readFanin(); k++){
			fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
			for(int i = 1; i <= timeframe; i++){
				fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(A" << k << "_f_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
			fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
			for(int i = 1; i <= timeframe; i++){
				fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(A" << k << "_t_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		fout << "//On-Feedback-of-F Fault" << endl;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(.ZN1(model" << temp << "_TF1), .TF1(PPI_f), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(ZN_f_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(.ZN1(model" << temp << "_TF1), .TF1(PPI_t), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(ZN_t_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		//Notyet
		fout << "//On-logic-out fault" << endl;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
		for(int i = 1; i <= timeframe; i++){
			fout << ".ZN" << i << "(ZN_f_TF" << i << "), .TF" << i << "(model" << temp << "_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
		for(int i = 1; i <= timeframe; i++){
			fout << ".ZN" << i << "(ZN_t_TF" << i << "), .TF" << i << "(model" << temp << "_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		//
		fout << "//On-LCD Fault" << endl;
		for(int k = 1; k <= GateList[j].readFanin(); k++){
			fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
			for(int i = 1; i <= timeframe; i++){
				fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(A" << k << "_f_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
			fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
			for(int i = 1; i <= timeframe; i++){
				fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(A" << k << "_t_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		for(int k = 1; k <= GateList[j].readFanin(); k++){
			fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
			for(int i = 1; i <= timeframe; i++){
				fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(B" << k << "_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		fout << "//On-RCD Fault" << endl;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(.ZN1(model" << temp << "_TF1), .TF1(PPI_f), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(ZN_f_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(.ZN1(model" << temp << "_TF1), .TF1(PPI_t), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(ZN_t_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "//On-C-element Fault" << endl;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
		for(int i = 1; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(LCD_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
		for(int i = 1; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(RCD_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(.ZN1(model" << temp << "_TF1), .TF1(PPI_c), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(AckL_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "//On-Ack Fault" << endl;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
		for(int i = 1; i <= timeframe; i++){
			fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(E1_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
		for(int i = 1; i <= timeframe; i++){
			fout << ".ZN" << i << "(AckL_TF" << i << "), .TF" << i << "(model" << temp << "_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		for(int k = 1; k <= 3; k++){
			fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
			for(int i = 1; i <= timeframe; i++){
				fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(AckR_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
			fout << "STUCKAT_FAULT_MODEL inst_model" << temp << "(";
			for(int i = 1; i <= timeframe; i++){
				fout << ".ZN" << i << "(model" << temp << "_TF" << i << "), .TF" << i << "(~model" << 5*GateList[j].readFanin()+10 << "_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		fout << endl;
		//End Inserting fault model

		// All timeframe logic
		for(int i = 1; i <= timeframe; i++){
			temp = 2*GateList[j].readFanin() + 4;
			for(int k = 1; k <= GateList[j].readFanin(); k++){
				fout << "CD inst_c" << k << "_TF" << i << "(.A1(model" << temp+1 << "_TF" << i << "), .A2(model" << temp+2 << "_TF" << i << "), .ZN(B" << k << "_TF" << i << "));" << endl;
				temp+=2;
			}
			temp = 5*GateList[j].readFanin() + 4;
			fout << "CD inst_c" << GateList[j].readFanin()+1 << "_TF" << i << "(.A1(model"<< temp+1 << "_TF" << i << "), .A2(model"<< temp+2 << "_TF" << i << "), .ZN(B" << GateList[j].readFanin()+1 << "_TF" << i << "));" << endl;
			temp = 4*GateList[j].readFanin() + 4;
			fout << "AND2_X1 inst_u1_TF" << i << "(.A1(model"<< temp+1 << "_TF" << i << "), .A2(model"<< temp+2 << "_TF" << i << "), .ZN(U1_TF" << i << "));" << endl;
			for(int k = 2; k <= GateList[j].readFanin()-1; k++){
				fout << "AND2_X1 inst_u" << k << "_TF" << i << "(.A1(U" << k-1 << "_TF" << i << "), .A2(model"<< temp+k+1 << "_TF" << i << "), .ZN(U" << k << "_TF" << i << "));" << endl;
			}
			fout << "AND2_X1 inst_u" << GateList[j].readFanin() << "_TF" << i << "(.A1(~reset_TF" << i << "), .A2(B" << GateList[j].readFanin()+1 << "_TF" << i << "), .ZN(RCD_TF" << i << "));" << endl;
			fout << "AND2_X1 inst_u" << GateList[j].readFanin()+1 << "_TF" << i << "(.A1(~reset_TF" << i << "), .A2(U" << GateList[j].readFanin()-1 << "_TF" << i << "), .ZN(LCD_TF" << i << "));" << endl;		
			temp = 5*GateList[j].readFanin() + 6;
			fout << "CEMT2 inst_e1_TF" << i << "(.A1(model"<< temp+1 << "_TF" << i << "), .A2(model"<< temp+2 << "_TF" << i << "), .ZN(E1_TF" << i << "), .PI(model"<< temp+3 << "_TF" << i << ") );" << endl;
			fout << "assign model"<< temp+5 << "_TF" << i << " = ~model"<< temp+4 << "_TF" << i << ";" << endl;
			temp = 1;
			for(int l= 0; l < GateList[j].readsizelogic(); l++){
				fout << GateList[j].readSublogic(l,0) << GateList[j].readsizeSublogic(l)-2 << "_X1 instl" << temp << "_TF" << i <<"(";
				temp++;
				for(int k = 1; k <= GateList[j].readsizeSublogic(l)-2; k++){
					if(GateList[j].readSublogic(l,k).compare("A1_f")==0)
						fout << ".A" << k << "(model1_TF" << i << "), "; 
					else if(GateList[j].readSublogic(l,k).compare("A1_t")==0)
						fout << ".A" << k << "(model2_TF" << i << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A2_f")==0)
						fout << ".A" << k << "(model3_TF" << i << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A2_t")==0)
						fout << ".A" << k << "(model4_TF" << i << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A3_f")==0)
						fout << ".A" << k << "(model5_TF" << i << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A3_t")==0)
						fout << ".A" << k << "(model6_TF" << i << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A4_f")==0)
						fout << ".A" << k << "(model7_TF" << i << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A4_t")==0)
						fout << ".A" << k << "(model8_TF" << i << "), ";
					else
						fout << ".A" << k << "(" << GateList[j].readSublogic(l,k) << "_TF" << i << "), "; 
				}
				fout << ".ZN(" << GateList[j].readSublogic(l,GateList[j].readsizeSublogic(l)-1) << "_TF" << i << "));" << endl;
			}
						temp = 5*GateList[j].readFanin() + 11;
			fout << "ATPG_control inst_a1_TF" << i << "(.enP(model" << temp+2 << "_TF" << i << "), .enN(model" << temp+6 << "_TF" << i << "), .pcP(model" << temp+1 << "_TF" << i << "), .pcN(model" << temp+5 << "_TF" << i << "), .Empty(Empty), .PI(O_t_TF" << i << "),";
			temp = 2*GateList[j].readFanin();
			fout << " .PPI(model" << temp+2 << "_TF" << i << "),";
			temp = 2*GateList[j].readFanin()+2;
			fout << " .ZN(model" << temp+2 << "_TF" << i << "));" << endl;
			temp = 5*GateList[j].readFanin() + 11;
			fout << "ATPG_control inst_a2_TF" << i << "(.enP(model" << temp+4 << "_TF" << i << "), .enN(model" << temp+6 << "_TF" << i << "), .pcP(model" << temp+3 << "_TF" << i << "), .pcN(model" << temp+5 << "_TF" << i << "), .Empty(Empty), .PI(O_f_TF" << i << "),";temp = 5*GateList[j].readFanin() + 4;
			temp = 2*GateList[j].readFanin();
			fout << " .PPI(model" << temp+1 << "_TF" << i << "), ";
			temp = 2*GateList[j].readFanin()+2;
			fout << ".ZN(model" << temp+1 << "_TF" << i << "));" << endl;
			fout << endl;
		}
		
		fout << "endmodule" << endl;
		fout << endl;
	}

}

void ModelFormatAnalyzer::printTDFTimeframeModel(string filename) {
	int temp;
	fstream fout;
	fout.open(filename.c_str(), ios::out);
	fout << "//Generated by LaDS PCHB Generator" << endl;
	
	/////// Idiot Implement method, require rewrite//////
	fout << "module CEMT2 (A1, A2, ZN, PI);" << endl;
	fout << "  input A1;" << endl;
	fout << "  input A2;" << endl;
	fout << "  input PI;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl;
	fout << "  AND2_X1 U1(.ZN(i_1), .A1(A1), .A2(A2));" << endl;
	fout << "  AND2_X1 U2(.ZN(i_2), .A1(A1), .A2(PI));" << endl;
	fout << "  AND2_X1 U3(.ZN(i_3), .A1(PI), .A2(A2));" << endl;
	fout << "  OR3_X1 U4(.ZN(ZN), .A1(i_1), .A2(i_2), .A3(i_3));" << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module CEMT3 (A1, A2, A3, ZN, PI);" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input A2;" << endl;
	fout << "  input A3;" << endl;
	fout << "  input PI;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl;
	fout << "  AND3_X1 U1(.ZN(i_1), .A1(A1), .A2(A2), .A3(A3));" << endl;
	fout << "  OR3_X1 U2(.ZN(i_2), .A1(A1), .A2(A2), .A3(A3));" << endl;
	fout << "  AND2_X1 U3(.ZN(i_3), .A1(PI), .A2(i_2));" << endl;
	fout << "  OR2_X1 U4(.ZN(ZN), .A1(i_1), .A2(i_3)); " << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module TSB (A1, EN, ZN, Empty); // Tristate Buffer" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input EN;" << endl;
	fout << "  input Empty;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl; 
	fout << "  AND2_X1 U1(.ZN(W1), .A1(A1), .A2(EN));" << endl;
	fout << "  AND2_X1 U2(.ZN(W2), .A1(Empty), .A2(~EN));" << endl;
	fout << "  OR2_X1 U3(.ZN(ZN), .A1(W1), .A2(W2)); " << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module RTSB (A1, EN, ZN, Empty); // Reverse Tristate Buffer" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input EN;" << endl;
	fout << "  input Empty;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl;  
	fout << "  AND2_X1 U1(.ZN(W1), .A1(A1), .A2(~EN));" << endl;
	fout << "  AND2_X1 U2(.ZN(W2), .A1(Empty), .A2(EN));" << endl;
	fout << "  OR2_X1 U3(.ZN(ZN), .A1(W1), .A2(W2)); " << endl;
	fout << endl; 
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module CD (A1, A2, ZN); // Completion Detector" << endl;
	fout << endl;
	fout << "  input A1;" << endl;
	fout << "  input A2;" << endl;
	fout << "  output ZN;" << endl;
	fout << endl; 
	fout << "  OR2_X1 U1(.ZN(ZN), .A1(A1), .A2(A2));" << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	fout << "module ATPG_control (enP, pcP, enN, pcN, Empty, PI, PPI, ZN);" << endl;
	fout << endl;
	fout << "  input enP, enN;" << endl;
	fout << "  input pcP, pcN;" << endl;
	fout << "  input Empty;" << endl;
	fout << "  input PI;" << endl;
	fout << "  input PPI;" << endl;
	fout << endl;
	fout << "  output ZN;" << endl;
	fout << endl;
	fout << "  AND2_X1 U1(.A1(~enP), .A2(~pcP), .ZN(W1));" << endl;
	fout << "  AND2_X1 U2(.A1(enN), .A2(pcN), .ZN(W2));" << endl;
	fout << "  AND3_X1 U3(.ZN(W3), .A1(~W1), .A2(~W2), .A3(PPI));	//Hold" << endl;
	fout << "  AND3_X1 U4(.ZN(W4), .A1(~W1), .A2(W2), .A3(PI));		//Evaluate" << endl;
	fout << "  AND3_X1 U5(.ZN(W5), .A1(W1), .A2(~W2), .A3(Empty));	//Precharge" << endl;
	fout << "  AND3_X1 U6(.ZN(W6), .A1(W1), .A2(W2), .A3(~Empty));	//High Impedence" << endl;
	fout << "  OR4_X1 U7(.ZN(ZN), .A1(W3), .A2(W4), .A3(W5), .A4(W6));" << endl;
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	/////// End //////
	
	//Implement Inverter
	fout << "module INV_PCHB_MODEL(";
	for(int i = 1; i <= timeframe; i++){
		fout << "A1_f_TF" << i << ", A1_t_TF" << i << ", ";
		if(i != timeframe)
			fout << "ZN_f_TF" << i << ", ZN_t_TF" << i << ", ";
		else
			fout << "ZN_f_TF" << i << ", ZN_t_TF" << i << ");" << endl;
	}
	fout << endl;
	for(int i = 1; i <= timeframe; i++){
		fout << "	input A1_f_TF" << i << ", A1_t_TF" << i << ";" << endl;
	}
	for(int i = 1; i <= timeframe; i++){
		fout << "	output ZN_f_TF" << i << ", ZN_t_TF" << i << ";" << endl;
	}
	fout << endl;
	for(int i = 1; i <= timeframe; i++){
		fout << "	assign ZN_f_TF" << i << " = A1_t_TF" << i << ";" << endl; 
		fout << "	assign ZN_t_TF" << i << " = A1_f_TF" << i << ";" << endl;
	}
	fout << endl;
	fout << "endmodule" << endl;
	fout << endl;
	
	//Implement Logic Gate
	for(int j = 0; j < GateList.size(); j++){
		fout << "module " << GateList[j].readName() << "_PCHB_DELAY_MODEL(";
		for(int i = 1; i <= timeframe; i++){
			fout << "AckR_TF" << i << ", AckL_TF" << i << ", ";
			for(int k = 1; k <= GateList[j].readFanin(); k++){
				fout << "A" << k << "_f_TF" << i << ", A" << k << "_t_TF" << i << ", ";
			}
			fout << "ZN_f_TF" << i << ", ZN_t_TF" << i << ", reset_TF" << i << ", ";
		}
		fout << "PPI_t, PPI_f, PPI_c, Empty, TIE_VALUE);" << endl;
		fout << endl;
		// I/O List 
		for(int i = 1; i <= timeframe; i++){
			fout << "input AckR_TF" << i << ", ";
			for(int k = 1; k <= GateList[j].readFanin(); k++){
				fout << "A" << k << "_f_TF" << i << ", A" << k << "_t_TF" << i << ", ";
			}
			fout << "reset_TF" << i << ";" << endl;
			fout << "output ZN_f_TF" << i << ", ZN_t_TF" << i << ", AckL_TF" << i << ";" << endl;
			
		}
		fout << "input PPI_t, PPI_f, PPI_c, Empty, TIE_VALUE;" << endl;
		fout << endl;
		// 1st timeframe logic
		for(int k = 1; k <= GateList[j].readFanin(); k++){
			fout << "CD inst_c" << k << "(.A1(A" << k << "_f_TF1), .A2(A" << k << "_t_TF1), .ZN(B" << k << "_TF1));" << endl;
		}
		fout << "CD inst_c" << GateList[j].readFanin()+1 << "(.A1(PPI_f), .A2(PPI_t), .ZN(B" << GateList[j].readFanin()+1 << "_TF1));" << endl;
		fout << "AND2_X1 inst_u1(.A1(B1_TF1), .A2(B2_TF1), .ZN(U1_TF1));" << endl;
		for(int k = 2; k <= GateList[j].readFanin()-1; k++){
			fout << "AND2_X1 inst_u" << k << "(.A1(U" << k-1 << "_TF1), .A2(B" << k+1 << "_TF1), .ZN(U" << k << "_TF1));" << endl;
		}
		fout << "AND2_X1 inst_u" << GateList[j].readFanin() << "(.A1(~reset_TF1), .A2(B" << GateList[j].readFanin()+1 << "_TF1), .ZN(RCD_TF1));" << endl;
		fout << "AND2_X1 inst_u" << GateList[j].readFanin()+1 << "(.A1(~reset_TF1), .A2(U" << GateList[j].readFanin()-1 << "_TF1), .ZN(LCD_TF1));" << endl;		
		fout << "CEMT2 inst_e1(.A1(LCD_TF1), .A2(RCD_TF1), .ZN(E1_TF1), .PI(PPI_c) );" << endl;
		fout << "assign AckL_TF1 = ~E1_TF1;" << endl;
		fout << endl;
		
		temp = 1;
		for(int i = 0; i < GateList[j].readsizelogic(); i++){
			fout << GateList[j].readSublogic(i,0) << GateList[j].readsizeSublogic(i)-2 << "_X1 instl" << temp << "_TF1(";
			for(int k = 1; k <= GateList[j].readsizeSublogic(i)-2; k++){
				fout << ".A" << k << "(" << GateList[j].readSublogic(i,k) << "_TF1), "; 
			}
			fout << ".ZN(" << GateList[j].readSublogic(i,GateList[j].readsizeSublogic(i)-1) << "_TF1));" << endl;
			temp++;
		}
		
		fout << "ATPG_control inst_a1(.enP(~E1_TF1), .enN(~E1_TF1), .pcP(AckR_TF1), .pcN(AckR_TF1), .Empty(Empty), .PI(O_t_TF1), .PPI(PPI_t), .ZN(ZN_t_TF1));" << endl;
		fout << "ATPG_control inst_a2(.enP(~E1_TF1), .enN(~E1_TF1), .pcP(AckR_TF1), .pcN(AckR_TF1), .Empty(Empty), .PI(O_f_TF1), .PPI(PPI_f), .ZN(ZN_f_TF1));" << endl;
		fout << endl;
		
		//Delay fault model
		temp = 1;
		fout << "//On-logic fault" << endl;
		for(int k = 1; k <= GateList[j].readFanin(); k++){
			fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(A" << k << "_f_TF1), ";
			for(int i = 2; i <= timeframe; i++){
				fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(A" << k << "_f_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
			fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(A" << k << "_t_TF1), ";
			for(int i = 2; i <= timeframe; i++){
				fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(A" << k << "_t_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		fout << "//On-Feedback-of-F Fault" << endl;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(PPI_f), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(ZN_f_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(PPI_t), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(ZN_t_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "//On-logic-out fault" << endl;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(ZN_f_TF1), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(ZN_f_TF" << i << "), .TF" << i << "(model" << temp << "_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(ZN_t_TF1), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(ZN_t_TF" << i << "), .TF" << i << "(model" << temp << "_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "//On-LCD Fault" << endl;
		for(int k = 1; k <= GateList[j].readFanin(); k++){
			fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(A" << k << "_f_TF1), ";
			for(int i = 2; i <= timeframe; i++){
				fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(A" << k << "_f_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
			fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(A" << k << "_t_TF1), ";
			for(int i = 2; i <= timeframe; i++){
				fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(A" << k << "_t_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		for(int k = 1; k <= GateList[j].readFanin(); k++){
			fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(B" << k <<"_TF1), ";
			for(int i = 2; i <= timeframe; i++){
				fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(B" << k << "_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		fout << "//On-RCD Fault" << endl;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(PPI_f), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(ZN_f_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(PPI_t), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(ZN_t_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "//On-C-element Fault" << endl;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(LCD_TF1), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(LCD_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(RCD_TF1), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(RCD_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(PPI_c), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(AckL_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "//On-Ack Fault" << endl;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(E1_TF1), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(E1_TF" << i << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(AckL_TF1), ";
		for(int i = 2; i <= timeframe; i++){
			fout << ".ZN" << i-1 << "(AckL_TF" << i << "), .TF" << i << "(model" << temp << "_TF" << i-1 << "), ";
		}
		fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
		temp++;
		for(int k = 1; k <= 3; k++){
			fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(AckR_TF1), ";
			for(int i = 2; i <= timeframe; i++){
				fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(AckR_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
			fout << "DELAY_FAULT_MODEL inst_model" << temp << "(.TF1(~E1_TF1), ";
			for(int i = 2; i <= timeframe; i++){
				fout << ".ZN" << i-1 << "(model" << temp << "_TF" << i-1 << "), .TF" << i << "(~E1_TF" << i << "), ";
			}
			fout << ".TIE_VALUE(TIE_VALUE) );" << endl;
			temp++;
		}
		fout << endl;
		//End Inserting fault model
		
		// Other timeframe logic
		for(int i = 2; i <= timeframe; i++){
			temp = 2*GateList[j].readFanin() + 4;
			for(int k = 1; k <= GateList[j].readFanin(); k++){
				fout << "CD inst_c" << k << "_TF" << i << "(.A1(model" << temp+1 << "_TF" << i-1 << "), .A2(model" << temp+2 << "_TF" << i-1 << "), .ZN(B" << k << "_TF" << i << "));" << endl;
				temp+=2;
			}
			temp = 5*GateList[j].readFanin() + 4;
			fout << "CD inst_c" << GateList[j].readFanin()+1 << "_TF" << i << "(.A1(model"<< temp+1 << "_TF" << i-1 << "), .A2(model"<< temp+2 << "_TF" << i-1 << "), .ZN(B" << GateList[j].readFanin()+1 << "_TF" << i << "));" << endl;
			temp = 4*GateList[j].readFanin() + 4;
			fout << "AND2_X1 inst_u1_TF" << i << "(.A1(model"<< temp+1 << "_TF" << i-1 << "), .A2(model"<< temp+2 << "_TF" << i-1 << "), .ZN(U1_TF" << i << "));" << endl;
			for(int k = 2; k <= GateList[j].readFanin()-1; k++){
				fout << "AND2_X1 inst_u" << k << "_TF" << i << "(.A1(U" << k-1 << "_TF" << i << "), .A2(model"<< temp+k+1 << "_TF" << i-1 << "), .ZN(U" << k << "_TF" << i << "));" << endl;
			}
			fout << "AND2_X1 inst_u" << GateList[j].readFanin() << "_TF" << i << "(.A1(~reset_TF" << i << "), .A2(B" << GateList[j].readFanin()+1 << "_TF" << i << "), .ZN(RCD_TF" << i << "));" << endl;
			fout << "AND2_X1 inst_u" << GateList[j].readFanin()+1 << "_TF" << i << "(.A1(~reset_TF" << i << "), .A2(U" << GateList[j].readFanin()-1 << "_TF" << i << "), .ZN(LCD_TF" << i << "));" << endl;		
			temp = 5*GateList[j].readFanin() + 6;
			fout << "CEMT2 inst_e1_TF" << i << "(.A1(model"<< temp+1 << "_TF" << i-1 << "), .A2(model"<< temp+2 << "_TF" << i-1 << "), .ZN(E1_TF" << i << "), .PI(model"<< temp+3 << "_TF" << i-1 << ") );" << endl;
			fout << "assign model"<< temp+5 << "_TF" << i-1 << " = ~model"<< temp+4 << "_TF" << i-1 << ";" << endl;
			temp = 1;
			for(int l= 0; l < GateList[j].readsizelogic(); l++){
				fout << GateList[j].readSublogic(l,0) << GateList[j].readsizeSublogic(l)-2 << "_X1 instl" << temp << "_TF" << i <<"(";
				temp++;
				for(int k = 1; k <= GateList[j].readsizeSublogic(l)-2; k++){
					if(GateList[j].readSublogic(l,k).compare("A1_f")==0)
						fout << ".A" << k << "(model1_TF" << i-1 << "), "; 
					else if(GateList[j].readSublogic(l,k).compare("A1_t")==0)
						fout << ".A" << k << "(model2_TF" << i-1 << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A2_f")==0)
						fout << ".A" << k << "(model3_TF" << i-1 << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A2_t")==0)
						fout << ".A" << k << "(model4_TF" << i-1 << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A3_f")==0)
						fout << ".A" << k << "(model5_TF" << i-1 << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A3_t")==0)
						fout << ".A" << k << "(model6_TF" << i-1 << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A4_f")==0)
						fout << ".A" << k << "(model7_TF" << i-1 << "), ";
					else if(GateList[j].readSublogic(l,k).compare("A4_t")==0)
						fout << ".A" << k << "(model8_TF" << i-1 << "), ";
					else
						fout << ".A" << k << "(" << GateList[j].readSublogic(l,k) << "_TF" << i << "), "; 
				}
				fout << ".ZN(" << GateList[j].readSublogic(l,GateList[j].readsizeSublogic(l)-1) << "_TF" << i << "));" << endl;
			}
						temp = 5*GateList[j].readFanin() + 11;
			fout << "ATPG_control inst_a1_TF" << i << "(.enP(model" << temp+2 << "_TF" << i-1 << "), .enN(model" << temp+6 << "_TF" << i-1 << "), .pcP(model" << temp+1 << "_TF" << i-1 << "), .pcN(model" << temp+5 << "_TF" << i-1 << "), .Empty(Empty), .PI(O_t_TF" << i << "),";
			temp = 2*GateList[j].readFanin();
			fout << " .PPI(model" << temp+2 << "_TF" << i-1 << "),";
			temp = 2*GateList[j].readFanin()+2;
			fout << " .ZN(model" << temp+2 << "_TF" << i-1 << "));" << endl;
			temp = 5*GateList[j].readFanin() + 11;
			fout << "ATPG_control inst_a2_TF" << i << "(.enP(model" << temp+4 << "_TF" << i-1 << "), .enN(model" << temp+6 << "_TF" << i-1 << "), .pcP(model" << temp+3 << "_TF" << i-1 << "), .pcN(model" << temp+5 << "_TF" << i-1 << "), .Empty(Empty), .PI(O_f_TF" << i << "),";temp = 5*GateList[j].readFanin() + 4;
			temp = 2*GateList[j].readFanin();
			fout << " .PPI(model" << temp+1 << "_TF" << i-1 << "), ";
			temp = 2*GateList[j].readFanin()+2;
			fout << ".ZN(model" << temp+1 << "_TF" << i-1 << "));" << endl;
			fout << endl;
		}
		
		fout << "endmodule" << endl;
		fout << endl;
	}
	
	
}


ModelGate::ModelGate(string n, int f ){
	name = n;
	fanin = f;
}

int	ModelGate::InsertLogic(string type ){
	logic.resize(logic.size()+1);
	logic[logic.size()-1].push_back(type);
	return logic.size();
}

void ModelGate::InsertSublogic(int ID, string pinname ){
	if(ID-1 < logic.size())
		logic[ID-1].push_back(pinname);
	else;
}

string ModelGate::readSublogic(int ID1, int ID2){
	
	if(ID1 < logic.size()){
		if(ID2 < logic[ID1].size()){
			return logic[ID1][ID2];
		}
	}
	return "Not defined";
}
