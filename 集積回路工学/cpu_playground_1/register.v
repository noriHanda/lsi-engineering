module register(CK,
                LD,
                BUS,
                OUT);
    input CK, LD;
    input [3:0] BUS;
    output [3:0] OUT;
    reg [3:0] q;
    
    initial q <= 4’d0;
    
    always @(posedge CK)
        if (LD)
            q    <= BUS;
            // q <= (LD) ? BUS : q;
    
    assign OUT = q;
endmodule
