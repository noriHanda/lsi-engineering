module dff (CK, D, Q, Q_bar);
    input CK, D;
    output Q, Q_bar;
    reg q;
    initial q <= 1'b0;
    always @(posedge CK)
        q <= D;
    assign Q = q;
    assign Q_bar = ~q;
endmodule

module testbench; 
    reg [1:0] CKreg;
    reg D, c; wire CK, Q, Q_bar;
    initial begin
        $monitor("%b CK:%b D:%b Q:%b Q_bar:%b", c, CK, D, Q, Q_bar);
        CKreg <= 2'b0;
        c     <= 1'b0;
        D     <= 1'b1;
        #7 $finish;
    end

    always begin
        #1
        c <= ~c;
        CKreg <= CKreg + 2'b1;
    end
    always #4 D <= ~D;
    assign CK = (CKreg == 2'b1) ? 1'b1 : 1'b0;
    dff inst0 (CK, D, Q, Q_bar);
endmodule
