module updownCounter_3bit(CK, R, UP, Q);
    input CK, R, UP;
    output [2:0] Q;
    reg [2:0] q;

    initial q <= 3'd0;

    always @(posedge CK)
        q <= (R == 1'b1) ? 3'd0 : (UP == 1'b1) ? q + 3'd1 : q - 3'd1;
        
    assign Q = q;
endmodule

module testbench;
    reg CK, UP;
    wire R;
    wire [2:0] Q;
    initial begin
        $monitor("CK:%b UP:%b Q:%d", CK, UP, Q);
        CK <= 1'b0;
        UP <= 1'b1;
        #15 $finish;
    end

    always #1 CK <= ~CK;
    always #8 UP <= ~UP;
    
    updownCounter_3bit inst0 (CK, 1'b0, UP, Q);
endmodule
