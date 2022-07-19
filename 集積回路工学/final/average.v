module AVG(Y,
           C,
           D,
           );
    input [8:0] Y;
    input [1:0] C;
    output [8:0] D;
    
    assign D = (Y+C)>>1;
endmodule
