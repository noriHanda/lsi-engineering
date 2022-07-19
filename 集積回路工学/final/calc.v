`include "add.v"
`include "cub.v"
`include "average.v"
`include "pipeline_registers.v"

module CALC(A,
            B,
            C,
            CK,
            D,
            );
    input [1:0] A;
    input [1:0] B;
    input [1:0] C;
    input CK;
    output [8:0] D;
    wire [2:0] X, X2;
    wire [1:0] C2, C3;
    wire [8:0] Y, Y2;
    
    ADD inst0 (A, B, X);
    PR3 inst1 (CK, X, X2);
    PR2 inst2 (CK, C, C2);
    CUB inst3 (X2, Y);
    PR9 inst4 (CK, Y, Y2);
    PR2 inst5 (CK, C2, C3);
    AVG inst6 (Y2, C3, D);
endmodule
