module testbench;
    reg CLK, RST_N;
    reg KEY, SEL;
    wire LED;
    wire [1:0] STATE;

    initial
    begin
        $dumpfile("led_flash.vcd");
        $dumpvars(0, testbench);
        $monitor("CLK:%b RST_N:%b KEY:%b SEL:%b LED:%b STATE:%d", CLK, RST_N, KEY, SEL, LED, STATE);
        CLK <= 0;
        RST_N <= 0;
        KEY <= 0;
        SEL <= 0;

        #4 RST_N <= 1;

        #10
            KEY <= 1;
        
        #2
            KEY <= 0;

        #20
            SEL <= 1;
        #10
            KEY <= 1;
        #2
            KEY <= 0;
        #10
            KEY <= 1;
        #2
            KEY <= 0;
        #10
            SEL <= 0;
        #20
            RST_N <= 0;
        #2
            RST_N <= 1;
        #10
            KEY <= 1;
            SEL <= 1;
        #2
            KEY <= 0;
        #20
            $finish;
    end

    always #1
        CLK <= ~CLK;

    led_flash led_flash_inst(CLK, RST_N, KEY, SEL, LED, STATE);


endmodule