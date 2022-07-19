module PR3 (CK,
            D,
            Q);
    input [2:0] D;
    output [2:0] Q;
    input CK;
    reg [2:0] q;
    
    always @(posedge CK)
        q <= D;
    
    assign Q = q;
endmodule

module PR2 (CK,
            D,
            Q);
    input [1:0] D;
    output [1:0] Q;
    input CK;
    reg [1:0] q;
    
    always @(posedge CK)
        q <= D;
    
    assign Q = q;
endmodule

module PR9 (CK,
            D,
            Q);
    input [8:0] D;
    output [8:0] Q;
    input CK;
    reg [8:0] q;
    
    always @(posedge CK)
        q <= D;
    
    assign Q = q;
endmodule
