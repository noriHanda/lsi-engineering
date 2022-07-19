module rsff(S, R, Q, Q_bar);
    input S, R;
    output Q, Q_bar;
    reg q;
    initial q <= 1'b0;
    always @(S || R) begin
        q <= (S && ~R) ? 1'b1 : (~S && R) ? 1'b0 : q;
    end
    assign Q     = q;
    assign Q_bar = ~q;
endmodule
    
module testbench;
    reg [1:0] Sreg, Rreg;
    wire Q, Q_bar;
    wire S, R;
    initial begin
        $monitor("S:%b R:%b Q:%b Q_bar:%b", S, R, Q, Q_bar);
        Sreg <= 0;
        Rreg <= 0;
        #3 $finish;
    end

    always #1 begin
        Sreg <= Sreg + 2'b1;
        Rreg <= Rreg + 2'b1;
    end

    assign S = (Sreg == 2'd0) ? 1'b1 : 1'b0;
    assign R = (Rreg == 2'd2) ? 1'b1 : 1'b0;
    
    rsff inst0 (S, R, Q, Q_bar);
endmodule
