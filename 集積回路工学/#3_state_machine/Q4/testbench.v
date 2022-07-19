module testbench;
    reg CLK, CLR;
    reg [3:0] KEY;
    reg OP;
    reg EVENT, EQUAL;
    wire [15:0] RESULT;
    wire [2:0] STATE;

    initial
    begin
        $dumpfile("adv_calc.vcd");
        $dumpvars(0, testbench);
        $monitor("CLK:%b CLR:%b KEY:%h OP:%b, EQUAL:%b, EVENT:%d, RESULT:%h, STATE:%d",
                  CLK, CLR, KEY, OP, EQUAL, EVENT, RESULT, STATE);
        CLK <= 0;
        CLR <= 0;
        KEY <= 0;
        OP <= 0;
        EVENT <= 0;
        EQUAL <= 0;

        #2
            CLR <= 1;
            EVENT <= 1;
        #2
            CLR <= 0;
            EVENT <= 0;


        // a1 + 5f
        #4
            KEY <= 4'ha;
            EVENT <= 1;
        #2
            KEY <= 4'h0;
            EVENT <= 0;
        #4
            KEY <= 4'h1;
            EVENT <= 1;
        #2
            KEY <= 4'h0;
            EVENT <= 0;
        #4
            OP <= 0;
            EVENT <= 1;
        #2
            EVENT <= 0;
        #4
            KEY <= 4'h5;
            EVENT <= 1;
        #2
            KEY <= 4'h0;
            EVENT <= 0;
        #4
            KEY <= 4'hf;
            EVENT <= 1;
        #2
            KEY <= 4'd0;
            EVENT <= 0;
        #4
            EQUAL <= 1;
            EVENT <= 1;
        #2
            EQUAL <= 0;
            EVENT <= 0;
        #4
            CLR <= 1;
            EVENT <= 1;
        #2
            CLR <= 0;
            EVENT <= 0;

        // b * f3
        #4
            KEY <= 4'hb;
            EVENT <= 1;
        #2
            KEY <= 4'h0;
            EVENT <= 0;
        #4
            OP <= 1;
            EVENT <= 1;
        #2
            OP <= 0;
            EVENT <= 0;
        #4
            KEY <= 4'hf;
            EVENT <= 1;
        #2
            KEY <= 4'h0;
            EVENT <= 0;
        #4
            KEY <= 4'h3;
            EVENT <= 1;
        #2
            KEY <= 4'h0;
            EVENT <= 0;
        #4
            EQUAL <= 1;
            EVENT <= 1;
        #2
            EQUAL <= 0;
            EVENT <= 0;
        #4
            $finish;
    end

    always #1
        CLK <= ~CLK;

    adv_calc adv_calcst(CLK, CLR, KEY, OP, EQUAL, EVENT, RESULT, STATE);

endmodule