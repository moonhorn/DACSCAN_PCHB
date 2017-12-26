module CEMT2 (A1, A2, ZN, PI);

  input A1;
  input A2;
  input PI;
  output ZN;

  AND2_X1 U1(.ZN(i_1), .A1(A1), .A2(A2));
  AND2_X1 U2(.ZN(i_2), .A1(A1), .A2(PI));
  AND2_X1 U3(.ZN(i_3), .A1(PI), .A2(A2));
  OR3_X1 U4(.ZN(ZN), .A1(i_1), .A2(i_2), .A3(i_3));

endmodule

module CEMT3 (A1, A2, A3, ZN, PI);

  input A1;
  input A2;
  input A3;
  input PI;
  output ZN;

  AND3_X1 U1(.ZN(i_1), .A1(A1), .A2(A2), .A3(A3));
  OR3_X1 U2(.ZN(i_2), .A1(A1), .A2(A2), .A3(A3));
  AND2_X1 U3(.ZN(i_3), .A1(PI), .A2(i_2));
  OR2_X1 U4(.ZN(ZN), .A1(i_1), .A2(i_3)); 

endmodule

module INV_DIMS (A_t, A_f, ZN_t, ZN_f, PI);

  input A_t;
  input A_f;
  input PI;
  output ZN_t;
  output ZN_f;

  assign ZN_t = A_f;
  assign ZN_f = A_t;

endmodule

module BUF_DIMS (A_t, A_f, Z_t, Z_f, PI);

  input A_t;
  input A_f;
  input PI;
  output Z_t;
  output Z_f;

  assign Z_t = A_t;
  assign Z_f = A_f;

endmodule

module AND2_DIMS (A1_t, A1_f, A2_t, A2_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT2 inst_c1(.ZN(c1), .A1(A1_f), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c2(.ZN(c2), .A1(A1_f), .A2(A2_t), .PI(PI) );
  CEMT2 inst_c3(.ZN(c3), .A1(A1_t), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c4(.ZN(ZN_t), .A1(A1_t), .A2(A2_t), .PI(PI) );
  OR3_X1 U1(.ZN(ZN_f), .A1(c1), .A2(c2), .A3(c3));

endmodule

module AND3_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT3 inst_c1(.ZN(c1), .A1(A1_f), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c2(.ZN(c2), .A1(A1_f), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c3(.ZN(c3), .A1(A1_f), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c4(.ZN(c4), .A1(A1_f), .A2(A2_t), .A3(A3_t), .PI(PI));
  CEMT3 inst_c5(.ZN(c5), .A1(A1_t), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c6(.ZN(c6), .A1(A1_t), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c7(.ZN(c7), .A1(A1_t), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c8(.ZN(ZN_t), .A1(A1_t), .A2(A2_t), .A3(A3_t), .PI(PI));
  OR4_X1 U1(.ZN(i_1), .A1(c1), .A2(c2), .A3(c3), .A4(c4));
  OR3_X1 U2(.ZN(i_2), .A1(c5), .A2(c6), .A3(c7));
  OR2_X1 U3(.ZN(ZN_f), .A1(i_1), .A2(i_2));

endmodule

module AND4_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, A4_t, A4_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input A4_t;
  input A4_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  AND2_DIMS inst_1(.A1_t(A1_t), .A1_f(A1_f), .A2_t(A2_t), .A2_f(A2_f), .ZN_t(ZN1_t), .ZN_f(ZN1_f), .PI(PI));
  AND2_DIMS inst_2(.A1_t(A3_t), .A1_f(A3_f), .A2_t(A4_t), .A2_f(A4_f), .ZN_t(ZN2_t), .ZN_f(ZN2_f), .PI(PI));
  AND2_DIMS inst_3(.A1_t(ZN1_t), .A1_f(ZN1_f), .A2_t(ZN2_t), .A2_f(ZN2_f), .ZN_t(ZN_t), .ZN_f(ZN_f), .PI(PI));

endmodule

module NAND2_DIMS (A1_t, A1_f, A2_t, A2_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT2 inst_c1(.ZN(c1), .A1(A1_f), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c2(.ZN(c2), .A1(A1_f), .A2(A2_t), .PI(PI) );
  CEMT2 inst_c3(.ZN(c3), .A1(A1_t), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c4(.ZN(ZN_f), .A1(A1_t), .A2(A2_t), .PI(PI) );
  OR3_X1 U1(.ZN(ZN_t), .A1(c1), .A2(c2), .A3(c3));

endmodule

module NAND3_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT3 inst_c1(.ZN(c1), .A1(A1_f), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c2(.ZN(c2), .A1(A1_f), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c3(.ZN(c3), .A1(A1_f), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c4(.ZN(c4), .A1(A1_f), .A2(A2_t), .A3(A3_t), .PI(PI));
  CEMT3 inst_c5(.ZN(c5), .A1(A1_t), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c6(.ZN(c6), .A1(A1_t), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c7(.ZN(c7), .A1(A1_t), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c8(.ZN(ZN_f), .A1(A1_t), .A2(A2_t), .A3(A3_t), .PI(PI));
  OR4_X1 U1(.ZN(i_1), .A1(c1), .A2(c2), .A3(c3), .A4(c4));
  OR3_X1 U2(.ZN(i_2), .A1(c5), .A2(c6), .A3(c7));
  OR2_X1 U3(.ZN(ZN_t), .A1(i_1), .A2(i_2));

endmodule

module NAND4_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, A4_t, A4_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input A4_t;
  input A4_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  AND2_DIMS inst_1(.A1_t(A1_t), .A1_f(A1_f), .A2_t(A2_t), .A2_f(A2_f), .ZN_t(ZN1_t), .ZN_f(ZN1_f), .PI(PI));
  AND2_DIMS inst_2(.A1_t(A3_t), .A1_f(A3_f), .A2_t(A4_t), .A2_f(A4_f), .ZN_t(ZN2_t), .ZN_f(ZN2_f), .PI(PI));
  NAND2_DIMS inst_3(.A1_t(ZN1_t), .A1_f(ZN1_f), .A2_t(ZN2_t), .A2_f(ZN2_f), .ZN_t(ZN_t), .ZN_f(ZN_f), .PI(PI));

endmodule

module OR2_DIMS (A1_t, A1_f, A2_t, A2_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT2 inst_c1(.ZN(ZN_f), .A1(A1_f), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c2(.ZN(c1), .A1(A1_f), .A2(A2_t), .PI(PI) );
  CEMT2 inst_c3(.ZN(c2), .A1(A1_t), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c4(.ZN(c3), .A1(A1_t), .A2(A2_t), .PI(PI) );
  OR3_X1 U1(.ZN(ZN_t), .A1(c1), .A2(c2), .A3(c3));

endmodule

module OR3_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT3 inst_c1(.ZN(ZN_f), .A1(A1_f), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c2(.ZN(c1), .A1(A1_f), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c3(.ZN(c2), .A1(A1_f), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c4(.ZN(c3), .A1(A1_f), .A2(A2_t), .A3(A3_t), .PI(PI));
  CEMT3 inst_c5(.ZN(c4), .A1(A1_t), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c6(.ZN(c5), .A1(A1_t), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c7(.ZN(c6), .A1(A1_t), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c8(.ZN(c7), .A1(A1_t), .A2(A2_t), .A3(A3_t), .PI(PI));
  OR4_X1 U1(.ZN(i_1), .A1(c1), .A2(c2), .A3(c3), .A4(c4));
  OR3_X1 U2(.ZN(i_2), .A1(c5), .A2(c6), .A3(c7));
  OR2_X1 U3(.ZN(ZN_t), .A1(i_1), .A2(i_2));

endmodule

module OR4_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, A4_t, A4_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input A4_t;
  input A4_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  OR2_DIMS inst_1(.A1_t(A1_t), .A1_f(A1_f), .A2_t(A2_t), .A2_f(A2_f), .ZN_t(ZN1_t), .ZN_f(ZN1_f), .PI(PI));
  OR2_DIMS inst_2(.A1_t(A3_t), .A1_f(A3_f), .A2_t(A4_t), .A2_f(A4_f), .ZN_t(ZN2_t), .ZN_f(ZN2_f), .PI(PI));
  OR2_DIMS inst_3(.A1_t(ZN1_t), .A1_f(ZN1_f), .A2_t(ZN2_t), .A2_f(ZN2_f), .ZN_t(ZN_t), .ZN_f(ZN_f), .PI(PI));

endmodule

module NOR2_DIMS (A1_t, A1_f, A2_t, A2_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT2 inst_c1(.ZN(ZN_t), .A1(A1_f), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c2(.ZN(c1), .A1(A1_f), .A2(A2_t), .PI(PI) );
  CEMT2 inst_c3(.ZN(c2), .A1(A1_t), .A2(A2_f), .PI(PI) );
  CEMT2 inst_c4(.ZN(c3), .A1(A1_t), .A2(A2_t), .PI(PI) );
  OR3_X1 U1(.ZN(ZN_f), .A1(c1), .A2(c2), .A3(c3));

endmodule

module NOR3_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT3 inst_c1(.ZN(ZN_t), .A1(A1_f), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c2(.ZN(c1), .A1(A1_f), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c3(.ZN(c2), .A1(A1_f), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c4(.ZN(c3), .A1(A1_f), .A2(A2_t), .A3(A3_t), .PI(PI));
  CEMT3 inst_c5(.ZN(c4), .A1(A1_t), .A2(A2_f), .A3(A3_f), .PI(PI));
  CEMT3 inst_c6(.ZN(c5), .A1(A1_t), .A2(A2_f), .A3(A3_t), .PI(PI));
  CEMT3 inst_c7(.ZN(c6), .A1(A1_t), .A2(A2_t), .A3(A3_f), .PI(PI));
  CEMT3 inst_c8(.ZN(c7), .A1(A1_t), .A2(A2_t), .A3(A3_t), .PI(PI));
  OR4_X1 U1(.ZN(i_1), .A1(c1), .A2(c2), .A3(c3), .A4(c4));
  OR3_X1 U2(.ZN(i_2), .A1(c5), .A2(c6), .A3(c7));
  OR2_X1 U3(.ZN(ZN_f), .A1(i_1), .A2(i_2));

endmodule

module NOR4_DIMS (A1_t, A1_f, A2_t, A2_f, A3_t, A3_f, A4_t, A4_f, ZN_t, ZN_f, PI);

  input A1_t;
  input A1_f;
  input A2_t;
  input A2_f;
  input A3_t;
  input A3_f;
  input A4_t;
  input A4_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  OR2_DIMS inst_1(.A1_t(A1_t), .A1_f(A1_f), .A2_t(A2_t), .A2_f(A2_f), .ZN_t(ZN1_t), .ZN_f(ZN1_f), .PI(PI));
  OR2_DIMS inst_2(.A1_t(A3_t), .A1_f(A3_f), .A2_t(A4_t), .A2_f(A4_f), .ZN_t(ZN2_t), .ZN_f(ZN2_f), .PI(PI));
  NOR2_DIMS inst_3(.A1_t(ZN1_t), .A1_f(ZN1_f), .A2_t(ZN2_t), .A2_f(ZN2_f), .ZN_t(ZN_t), .ZN_f(ZN_f), .PI(PI));

endmodule

module XOR2_DIMS (A_t, A_f, B_t, B_f, Z_t, Z_f, PI);

  input A_t;
  input A_f;
  input B_t;
  input B_f;
  input PI;
  output Z_t;
  output Z_f;
  
  CEMT2 inst_c1(.ZN(c1), .A1(A_f), .A2(B_f), .PI(PI) );
  CEMT2 inst_c2(.ZN(c2), .A1(A_f), .A2(B_t), .PI(PI) );
  CEMT2 inst_c3(.ZN(c3), .A1(A_t), .A2(B_f), .PI(PI) );
  CEMT2 inst_c4(.ZN(c4), .A1(A_t), .A2(B_t), .PI(PI) );
  OR2_X1 U1(.ZN(Z_f), .A1(c1), .A2(c4));
  OR2_X1 U2(.ZN(Z_t), .A1(c2), .A2(c3));

endmodule

module XOR3_DIMS (A_t, A_f, B_t, B_f, C_t, C_f, Z_t, Z_f, PI);

  input A_t;
  input A_f;
  input B_t;
  input B_f;
  input C_t;
  input C_f;
  input PI;
  output Z_t;
  output Z_f;
  
  CEMT3 inst_c1(.ZN(c1), .A1(A_f), .A2(B_f), .A3(C_f), .PI(PI));
  CEMT3 inst_c2(.ZN(c2), .A1(A_f), .A2(B_f), .A3(C_t), .PI(PI));
  CEMT3 inst_c3(.ZN(c3), .A1(A_f), .A2(B_t), .A3(C_f), .PI(PI));
  CEMT3 inst_c4(.ZN(c4), .A1(A_f), .A2(B_t), .A3(C_t), .PI(PI));
  CEMT3 inst_c5(.ZN(c5), .A1(A_t), .A2(B_f), .A3(C_f), .PI(PI));
  CEMT3 inst_c6(.ZN(c6), .A1(A_t), .A2(B_f), .A3(C_t), .PI(PI));
  CEMT3 inst_c7(.ZN(c7), .A1(A_t), .A2(B_t), .A3(C_f), .PI(PI));
  CEMT3 inst_c8(.ZN(c8), .A1(A_t), .A2(B_t), .A3(C_t), .PI(PI));
  OR4_X1 U1(.ZN(Z_f), .A1(c1), .A2(c4), .A3(c6), .A4(c7));
  OR4_X1 U2(.ZN(Z_t), .A1(c2), .A2(c3), .A3(c5), .A4(c8));

endmodule

module XNOR2_DIMS (A_t, A_f, B_t, B_f, ZN_t, ZN_f, PI);

  input A_t;
  input A_f;
  input B_t;
  input B_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT2 inst_c1(.ZN(c1), .A1(A_f), .A2(B_f), .PI(PI) );
  CEMT2 inst_c2(.ZN(c2), .A1(A_f), .A2(B_t), .PI(PI) );
  CEMT2 inst_c3(.ZN(c3), .A1(A_t), .A2(B_f), .PI(PI) );
  CEMT2 inst_c4(.ZN(c4), .A1(A_t), .A2(B_t), .PI(PI) );
  OR2_X1 U1(.ZN(ZN_t), .A1(c1), .A2(c4));
  OR2_X1 U2(.ZN(ZN_f), .A1(c2), .A2(c3));

endmodule

module XNOR3_DIMS (A_t, A_f, B_t, B_f, C_t, C_f, ZN_t, ZN_f, PI);

  input A_t;
  input A_f;
  input B_t;
  input B_f;
  input C_t;
  input C_f;
  input PI;
  output ZN_t;
  output ZN_f;
  
  CEMT3 inst_c1(.ZN(c1), .A1(A_f), .A2(B_f), .A3(C_f), .PI(PI));
  CEMT3 inst_c2(.ZN(c2), .A1(A_f), .A2(B_f), .A3(C_t), .PI(PI));
  CEMT3 inst_c3(.ZN(c3), .A1(A_f), .A2(B_t), .A3(C_f), .PI(PI));
  CEMT3 inst_c4(.ZN(c4), .A1(A_f), .A2(B_t), .A3(C_t), .PI(PI));
  CEMT3 inst_c5(.ZN(c5), .A1(A_t), .A2(B_f), .A3(C_f), .PI(PI));
  CEMT3 inst_c6(.ZN(c6), .A1(A_t), .A2(B_f), .A3(C_t), .PI(PI));
  CEMT3 inst_c7(.ZN(c7), .A1(A_t), .A2(B_t), .A3(C_f), .PI(PI));
  CEMT3 inst_c8(.ZN(c8), .A1(A_t), .A2(B_t), .A3(C_t), .PI(PI));
  OR4_X1 U1(.ZN(ZN_t), .A1(c1), .A2(c4), .A3(c6), .A4(c7));
  OR4_X1 U2(.ZN(ZN_f), .A1(c2), .A2(c3), .A3(c5), .A4(c8));

endmodule

