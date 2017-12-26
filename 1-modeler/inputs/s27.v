//
// bench2vlog.py
//   options: -l nangate --clk CK --si test_si --so test_so --se test_se
//
module s27 (CK,  G0, G1, G2, G3, G17);

input G0 ;
input G1 ;
input G2 ;
input G3 ;
input CK ;

output G17 ;

//startLogic
INV_X32 U_G14 ( .A(G0), .ZN(G14) );
INV_X32 U_G17 ( .A(G11), .ZN(G17) );
AND2_X4 U_G8 ( .A1(G14), .A2(G6), .ZN(G8) );
OR2_X4 U_G15 ( .A1(G12), .A2(G8), .ZN(G15) );
OR2_X4 U_G16 ( .A1(G3), .A2(G8), .ZN(G16) );
NAND2_X4 U_G9 ( .A1(G16), .A2(G15), .ZN(G9) );
NOR2_X4 U_G10 ( .A1(G14), .A2(G11), .ZN(G10) );
NOR2_X4 U_G11 ( .A1(G5), .A2(G9), .ZN(G11) );
NOR2_X4 U_G12 ( .A1(G1), .A2(G7), .ZN(G12) );
NOR2_X4 U_G13 ( .A1(G2), .A2(G12), .ZN(G13) );

DFF_X2 U_G5 ( .D(G10), .Q(G5), .CK(CK) );
DFF_X2 U_G6 ( .D(G11), .Q(G6), .CK(CK) );
DFF_X2 U_G7 ( .D(G13), .Q(G7), .CK(CK) );


endmodule

