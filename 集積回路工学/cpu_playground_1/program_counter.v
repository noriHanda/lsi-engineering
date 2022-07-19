module programCounter(CK,
                      LD_PC,
                      AD,
                      OUT);
    input CK, LD_PC;
    input [3:0] AD;
    output [3:0] OUT;
    reg [3:0] q;
    
    initial q <= 4’d0;
    
    always @(posedge CK)
        q <= (LD_PC) ? AD : q + 4’d1;
    
    assign OUT = q;
endmodule
