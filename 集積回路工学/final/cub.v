module CUB(X,
           Y,
           );
    input [2:0] X;
    output [8:0] Y;
    
    assign Y = X*X*X;
endmodule
