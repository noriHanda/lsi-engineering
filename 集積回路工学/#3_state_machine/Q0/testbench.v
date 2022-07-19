module testbench;
    reg CLK, RST_N;
    reg KEY;
    wire LED;
    wire STATE;

    initial
    begin
        $dumpfile("led_ex.vcd");
        $dumpvars(0, testbench);
        $monitor("CLK:%b RST_N:%b SEL:%b LED:%b STATE:%d", CLK, RST_N, KEY, LED, STATE);
        CLK <= 0;
        RST_N <= 0;
        KEY <= 0;

        #4  RST_N <= 1;
        #10 KEY <= 1;
        #2  KEY <= 0;
        #10 KEY <= 1;
        #2  KEY <= 0;
        #10 KEY <= 1;
        #2  KEY <= 0;
        #10 RST_N <= 0;
        #2  RST_N <= 1;
        #10 KEY <= 1;
        #2  KEY <= 0;
        #20 $finish;
    end

    always #1
        CLK <= ~CLK;

    led_ex led_ex_inst(CLK, RST_N, KEY, LED, STATE);

endmodule