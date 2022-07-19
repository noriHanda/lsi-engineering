module ADD(A,
           B,
           X);
    input [1:0] A, B;
    output [2:0] X;
    
    assign X = A + B;
endmodule
