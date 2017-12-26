// **************************************************************************
// File       [ dims_lib_extend_behavior.v ]
// Author     [ roger0514 ]
// Synopsis   [ ]
// Date       [ 2014/11/05 modified ]
// **************************************************************************

module AOI211_DIMS ( A_f, A_t, B_f, B_t, C1_f, C1_t, C2_f, C2_t, ZN_f, ZN_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B_f;
  input B_t;
  input C1_f;
  input C1_t;
  input C2_f;
  input C2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_18_f), .A_t(i_18_t), .PI(PI) );
  OR2_DIMS U1( .ZN_f(i_18_f), .ZN_t(i_18_t), .A1_f(i_19_f), .A1_t(i_19_t), .A2_f(A_f), .A2_t(A_t), .PI(PI) );
  OR2_DIMS U2( .ZN_f(i_19_f), .ZN_t(i_19_t), .A1_f(i_20_f), .A1_t(i_20_t), .A2_f(B_f), .A2_t(B_t), .PI(PI) );
  AND2_DIMS U3( .ZN_f(i_20_f), .ZN_t(i_20_t), .A1_f(C1_f), .A1_t(C1_t), .A2_f(C2_f), .A2_t(C2_t), .PI(PI) );

endmodule

module AOI21_DIMS ( A_f, A_t, B1_f, B1_t, B2_f, B2_t, ZN_f, ZN_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_12_f), .A_t(i_12_t), .PI(PI) );
  OR2_DIMS U1( .ZN_f(i_12_f), .ZN_t(i_12_t), .A1_f(A_f), .A1_t(A_t), .A2_f(i_13_f), .A2_t(i_13_t), .PI(PI) );
  AND2_DIMS U2( .ZN_f(i_13_f), .ZN_t(i_13_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );

endmodule

module AOI221_DIMS ( A_f, A_t, B1_f, B1_t, B2_f, B2_t, C1_f, C1_t, C2_f, C2_t, ZN_f, ZN_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  input C1_f;
  input C1_t;
  input C2_f;
  input C2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_24_f), .A_t(i_24_t), .PI(PI) );
  OR2_DIMS U1( .ZN_f(i_24_f), .ZN_t(i_24_t), .A1_f(i_25_f), .A1_t(i_25_t), .A2_f(i_27_f), .A2_t(i_27_t), .PI(PI) );
  OR2_DIMS U2( .ZN_f(i_25_f), .ZN_t(i_25_t), .A1_f(i_26_f), .A1_t(i_26_t), .A2_f(A_f), .A2_t(A_t), .PI(PI) );
  AND2_DIMS U3( .ZN_f(i_26_f), .ZN_t(i_26_t), .A1_f(C1_f), .A1_t(C1_t), .A2_f(C2_f), .A2_t(C2_t), .PI(PI) );
  AND2_DIMS U4( .ZN_f(i_27_f), .ZN_t(i_27_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );

endmodule


module AOI222_DIMS ( A1_f, A1_t, A2_f, A2_t, B1_f, B1_t, B2_f, B2_t, C1_f, C1_t, C2_f, C2_t, ZN_f, ZN_t, PI);

  input PI;
  input A1_f;
  input A1_t;
  input A2_f;
  input A2_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  input C1_f;
  input C1_t;
  input C2_f;
  input C2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_30_f), .A_t(i_30_t), .PI(PI) );
  OR2_DIMS U1( .ZN_f(i_30_f), .ZN_t(i_30_t), .A1_f(i_31_f), .A1_t(i_31_t), .A2_f(i_34_f), .A2_t(i_34_t), .PI(PI) );
  OR2_DIMS U2( .ZN_f(i_31_f), .ZN_t(i_31_t), .A1_f(i_32_f), .A1_t(i_32_t), .A2_f(i_33_f), .A2_t(i_33_t), .PI(PI) );
  AND2_DIMS U3( .ZN_f(i_32_f), .ZN_t(i_32_t), .A1_f(A1_f), .A1_t(A1_t), .A2_f(A2_f), .A2_t(A2_t), .PI(PI) );
  AND2_DIMS U4( .ZN_f(i_33_f), .ZN_t(i_33_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );
  AND2_DIMS U5( .ZN_f(i_34_f), .ZN_t(i_34_t), .A1_f(C1_f), .A1_t(C1_t), .A2_f(C2_f), .A2_t(C2_t), .PI(PI) );

endmodule

module AOI22_DIMS ( A1_f, A1_t, A2_f, A2_t, B1_f, B1_t, B2_f, B2_t, ZN_f, ZN_t, PI);

  input PI;
  input A1_f;
  input A1_t;
  input A2_f;
  input A2_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_18_f), .A_t(i_18_t), .PI(PI) );
  OR2_DIMS U1( .ZN_f(i_18_f), .ZN_t(i_18_t), .A1_f(i_19_f), .A1_t(i_19_t), .A2_f(i_20_f), .A2_t(i_20_t), .PI(PI) );
  AND2_DIMS U2( .ZN_f(i_19_f), .ZN_t(i_19_t), .A1_f(A1_f), .A1_t(A1_t), .A2_f(A2_f), .A2_t(A2_t), .PI(PI) );
  AND2_DIMS U3( .ZN_f(i_20_f), .ZN_t(i_20_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );

endmodule

module OAI211_DIMS ( A_f, A_t, B_f, B_t, C1_f, C1_t, C2_f, C2_t, ZN_f, ZN_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B_f;
  input B_t;
  input C1_f;
  input C1_t;
  input C2_f;
  input C2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_18_f), .A_t(i_18_t), .PI(PI) );
  AND2_DIMS U1( .ZN_f(i_18_f), .ZN_t(i_18_t), .A1_f(i_19_f), .A1_t(i_19_t), .A2_f(B_f), .A2_t(B_t), .PI(PI) );
  AND2_DIMS U2( .ZN_f(i_19_f), .ZN_t(i_19_t), .A1_f(i_20_f), .A1_t(i_20_t), .A2_f(A_f), .A2_t(A_t), .PI(PI) );
  OR2_DIMS U3( .ZN_f(i_20_f), .ZN_t(i_20_t), .A1_f(C1_f), .A1_t(C1_t), .A2_f(C2_f), .A2_t(C2_t), .PI(PI) );

endmodule

module OAI21_DIMS ( A_f, A_t, B1_f, B1_t, B2_f, B2_t, ZN_f, ZN_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_12_f), .A_t(i_12_t), .PI(PI) );
  AND2_DIMS U1( .ZN_f(i_12_f), .ZN_t(i_12_t), .A1_f(A_f), .A1_t(A_t), .A2_f(i_13_f), .A2_t(i_13_t), .PI(PI) );
  OR2_DIMS U2( .ZN_f(i_13_f), .ZN_t(i_13_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );

endmodule

module OAI221_DIMS ( A_f, A_t, B1_f, B1_t, B2_f, B2_t, C1_f, C1_t, C2_f, C2_t, ZN_f, ZN_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  input C1_f;
  input C1_t;
  input C2_f;
  input C2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_24_f), .A_t(i_24_t), .PI(PI) );
  AND2_DIMS U1( .ZN_f(i_24_f), .ZN_t(i_24_t), .A1_f(i_25_f), .A1_t(i_25_t), .A2_f(i_27_f), .A2_t(i_27_t), .PI(PI) );
  AND2_DIMS U2( .ZN_f(i_25_f), .ZN_t(i_25_t), .A1_f(i_26_f), .A1_t(i_26_t), .A2_f(A_f), .A2_t(A_t), .PI(PI) );
  OR2_DIMS U3( .ZN_f(i_26_f), .ZN_t(i_26_t), .A1_f(C1_f), .A1_t(C1_t), .A2_f(C2_f), .A2_t(C2_t), .PI(PI) );
  OR2_DIMS U4( .ZN_f(i_27_f), .ZN_t(i_27_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );

endmodule

module OAI222_DIMS ( A1_f, A1_t, A2_f, A2_t, B1_f, B1_t, B2_f, B2_t, C1_f, C1_t, C2_f, C2_t, ZN_f, ZN_t, PI);

  input PI;
  input A1_f;
  input A1_t;
  input A2_f;
  input A2_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  input C1_f;
  input C1_t;
  input C2_f;
  input C2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_30_f), .A_t(i_30_t), .PI(PI) );
  AND2_DIMS U1( .ZN_f(i_30_f), .ZN_t(i_30_t), .A1_f(i_31_f), .A1_t(i_31_t), .A2_f(i_34_f), .A2_t(i_34_t), .PI(PI) );
  AND2_DIMS U2( .ZN_f(i_31_f), .ZN_t(i_31_t), .A1_f(i_32_f), .A1_t(i_32_t), .A2_f(i_33_f), .A2_t(i_33_t), .PI(PI) );
  OR2_DIMS U3( .ZN_f(i_32_f), .ZN_t(i_32_t), .A1_f(A1_f), .A1_t(A1_t), .A2_f(A2_f), .A2_t(A2_t), .PI(PI) );
  OR2_DIMS U4( .ZN_f(i_33_f), .ZN_t(i_33_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );
  OR2_DIMS U5( .ZN_f(i_34_f), .ZN_t(i_34_t), .A1_f(C1_f), .A1_t(C1_t), .A2_f(C2_f), .A2_t(C2_t), .PI(PI) );

endmodule

module OAI22_DIMS ( A1_f, A1_t, A2_f, A2_t, B1_f, B1_t, B2_f, B2_t, ZN_f, ZN_t, PI);

  input PI;
  input A1_f;
  input A1_t;
  input A2_f;
  input A2_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_18_f), .A_t(i_18_t), .PI(PI) );
  AND2_DIMS U1( .ZN_f(i_18_f), .ZN_t(i_18_t), .A1_f(i_19_f), .A1_t(i_19_t), .A2_f(i_20_f), .A2_t(i_20_t), .PI(PI) );
  OR2_DIMS U2( .ZN_f(i_19_f), .ZN_t(i_19_t), .A1_f(A1_f), .A1_t(A1_t), .A2_f(A2_f), .A2_t(A2_t), .PI(PI) );
  OR2_DIMS U3( .ZN_f(i_20_f), .ZN_t(i_20_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );

endmodule

module OAI33_DIMS ( A1_f, A1_t, A2_f, A2_t, A3_f, A3_t, B1_f, B1_t, B2_f, B2_t, B3_f, B3_t, ZN_f, ZN_t, PI);

  input PI;
  input A1_f;
  input A1_t;
  input A2_f;
  input A2_t;
  input A3_f;
  input A3_t;
  input B1_f;
  input B1_t;
  input B2_f;
  input B2_t;
  input B3_f;
  input B3_t;
  output ZN_f;
  output ZN_t;

  INV_DIMS U0( .ZN_f(ZN_f), .ZN_t(ZN_t), .A_f(i_30_f), .A_t(i_30_t), .PI(PI) );
  AND2_DIMS U1( .ZN_f(i_30_f), .ZN_t(i_30_t), .A1_f(i_31_f), .A1_t(i_31_t), .A2_f(i_33_f), .A2_t(i_33_t), .PI(PI) );
  OR2_DIMS U2( .ZN_f(i_31_f), .ZN_t(i_31_t), .A1_f(i_32_f), .A1_t(i_32_t), .A2_f(A3_f), .A2_t(A3_t), .PI(PI) );
  OR2_DIMS U3( .ZN_f(i_32_f), .ZN_t(i_32_t), .A1_f(A1_f), .A1_t(A1_t), .A2_f(A2_f), .A2_t(A2_t), .PI(PI) );
  OR2_DIMS U4( .ZN_f(i_33_f), .ZN_t(i_33_t), .A1_f(i_34_f), .A1_t(i_34_t), .A2_f(B3_f), .A2_t(B3_t), .PI(PI) );
  OR2_DIMS U5( .ZN_f(i_34_f), .ZN_t(i_34_t), .A1_f(B1_f), .A1_t(B1_t), .A2_f(B2_f), .A2_t(B2_t), .PI(PI) );

endmodule

module HA_DIMS ( A_f, A_t, B_f, B_t, CO_f, CO_t, S_f, S_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B_f;
  input B_t;
  output CO_f;
  output CO_t;
  output S_f;
  output S_t;

  AND2_DIMS U0( .ZN_f(CO_f), .ZN_t(CO_t), .A1_f(A_f), .A1_t(A_t), .A2_f(B_f), .A2_t(B_t), .PI(PI) );
  XOR2_DIMS U1( .Z_f(S_f), .Z_t(S_t), .A_f(A_f), .A_t(A_t), .B_f(B_f), .B_t(B_t), .PI(PI) );

endmodule

module FA_DIMS ( A_f, A_t, B_f, B_t, CI_f, CI_t, CO_f, CO_t, S_f, S_t, PI);

  input PI;
  input A_f;
  input A_t;
  input B_f;
  input B_t;
  input CI_f;
  input CI_t;
  output CO_f;
  output CO_t;
  output S_f;
  output S_t;

  OR2_DIMS U0( .ZN_f(CO_f), .ZN_t(CO_t), .A1_f(i_24_f), .A1_t(i_24_t), .A2_f(i_25_f), .A2_t(i_25_t), .PI(PI) );
  AND2_DIMS U1( .ZN_f(i_24_f), .ZN_t(i_24_t), .A1_f(A_f), .A1_t(A_t), .A2_f(B_f), .A2_t(B_t), .PI(PI) );
  AND2_DIMS U2( .ZN_f(i_25_f), .ZN_t(i_25_t), .A1_f(CI_f), .A1_t(CI_t), .A2_f(i_26_f), .A2_t(i_26_t), .PI(PI) );
  OR2_DIMS U3( .ZN_f(i_26_f), .ZN_t(i_26_t), .A1_f(A_f), .A1_t(A_t), .A2_f(B_f), .A2_t(B_t), .PI(PI) );
  XOR2_DIMS U4( .Z_f(S_f), .Z_t(S_t), .A_f(CI_f), .A_t(CI_t), .B_f(i_30_f), .B_t(i_30_t), .PI(PI) );
  XOR2_DIMS U5( .Z_f(i_30_f), .Z_t(i_30_t), .A_f(A_f), .A_t(A_t), .B_f(B_f), .B_t(B_t), .PI(PI) );

endmodule

module MUX_DIMS (A_f, A_t, B_f, B_t, S_f, S_t, Z_f, Z_t, PI); 

  input A_f;
  input A_t;
  input B_f;
  input B_t;
  input S_f;
  input S_t;
  output Z_f;
  output Z_t;
  input PI;

INV_DIMS U0(.ZN_f(i_24_f), .ZN_t(i_24_t), .A_f(S_f), .A_t(S_t), .PI(PI) ); 
AND2_DIMS U1(.ZN_f(i_25_f), .ZN_t(i_25_t), .A1_f(A_f), .A1_t(A_t), .A2_f(i_24_f), .A2_t(i_24_t), .PI(PI)  ); 
AND2_DIMS U2(.ZN_f(i_26_f), .ZN_t(i_26_t), .A1_f(B_f), .A1_t(B_t), .A2_f(S_f), .A2_t(S_t), .PI(PI) ); 
OR2_DIMS U3(.ZN_f(Z_f), .ZN_t(Z_t), .A1_f(i_25_f), .A1_t(i_25_t), .A2_f(i_26_f), .A2_t(i_26_t), .PI(PI) ); 

endmodule

module DEMUX_DIMS (A_f, A_t, S_f, S_t, Y_f, Y_t, Z_f, Z_t, PI); 

  input A_f;
  input A_t;
  input S_f;
  input S_t;
  output Y_f;
  output Y_t;
  output Z_f;
  output Z_t;
  input PI;

INV_DIMS U0(.ZN_f(i_24_f), .ZN_t(i_24_t), .A_f(S_f), .A_t(S_t), .PI(PI) ); 
AND2_DIMS U1(.ZN_f(Y_f), .ZN_t(Y_t), .A1_f(A_f), .A1_t(A_t), .A2_f(i_24_f), .A2_t(i_24_t), .PI(PI) ); 
AND2_DIMS U2(.ZN_f(Z_f), .ZN_t(Z_t), .A1_f(A_f), .A1_t(A_t), .A2_f(S_f), .A2_t(S_t), .PI(PI) ); 

endmodule



