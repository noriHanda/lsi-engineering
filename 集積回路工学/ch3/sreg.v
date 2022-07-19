module sreg(d,
            ck);
    input ck;
    output [3:0] d;
    reg [3:0] q;
    assign d = q;
    
    initial
    begin
        q    <= 0;
        q[0] <= 1;
    end
    
    always @(posedge ck)
    begin
        q[1] <= q[0];
        q[2] <= q[1];
        q[3] <= q[2];
        q[0] <= q[3];
    end
endmodule

module testbench;
    reg ck;
    wire [3:0] d;

    initial
    begin
        $dumpfile("sreg.vcd");
        $dumpvars(0, testbench);
        $monitor("%t: ck:%b d:%b", $time, ck, d);
        ck <= 0;
        #9
            $finish;
    end

    always #1
        ck <= ~ck;

    sreg inst0 (d, ck);
endmodule