module CEMT2 (A1, A2, B1, B2, ZN, PI);
  input A1, A2;
  input B1, B2;
  input PI;
  output ZN;

  OR2_X1 U1(.ZN(temp1), .A1(A1), .A2(B1));
  AND2_X1 U2(.ZN(temp2), .A1(A2), .A2(B2));
  AND3_X1 U3(.ZN(temp3), .A1(temp1), .A2(temp2), .A3(1'b1));
  AND3_X1 U4(.ZN(temp4), .A1(~temp1), .A2(temp2), .A3(1'bx));
  AND3_X1 U5(.ZN(temp5), .A1(temp1), .A2(~temp2), .A3(PI));
  AND3_X1 U6(.ZN(temp6), .A1(~temp1), .A2(~temp2), .A3(1'b0));
  OR4_X1 U7(.ZN(ZN), .A1(temp3), .A2(temp4), .A3(temp5), .A4(temp6));
  
endmodule

module CD (A1, A2, B1, B2, ZN);

  input A1;
  input A2;
  output ZN;

  OR2_X1 U1(.ZN(temp1), .A1(A1), .A2(B1));
  OR2_X1 U2(.ZN(temp2), .A1(A2), .A2(B2));
  AND3_X1 U3(.ZN(temp3), .A1(temp1), .A2(temp2), .A3(1'b1));
  AND3_X1 U4(.ZN(temp4), .A1(~temp1), .A2(temp2), .A3(1'bx));
  AND3_X1 U5(.ZN(temp5), .A1(temp1), .A2(~temp2), .A3(1'bz));
  AND3_X1 U6(.ZN(temp6), .A1(~temp1), .A2(~temp2), .A3(1'b0));
  OR4_X1 U7(.ZN(ZN), .A1(temp3), .A2(temp4), .A3(temp5), .A4(temp6));

endmodule