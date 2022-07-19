module upCounter_3bit(CK, R, Q);
    input CK, R;
    output [2:0] Q;
    reg [2:0] q;
    initial q <= 3'b0;
    always @(posedge CK)
        q <= (R == 1'b1) ? 3'd0 : q+ 3'd1;
        assign Q = q;
endmodule
    
module testbench; 
    reg [3:0] Rreg;
    reg CK;
    wire R;
    wire [2:0] Q;
    initial begin
        $monitor("CK:%b R:%b Q:%d", CK, R, Q);
        CK   <= 0;
        Rreg <= 0;
        #15 $finish;
    end

    always #1 CK   <= ~CK;
    always #1 Rreg <= Rreg + 4'b1;

    assign R = (Rreg == 4'd6) ? 1'b1 : 1'b0;

    upCounter_3bit inst0 (CK, R, Q);
endmodule
