module testbench;
    reg CLK, CLR;
    reg [3:0] KEY;
    reg OP;
    reg EVENT, EQUAL;
    wire [7:0] RESULT;
    wire [2:0] STATE;

    initial
    begin
        $dumpfile("calc.vcd");
        $dumpvars(0, testbench);
        $monitor("CLK:%b CLR:%b KEY:%d OP:%b, EQUAL:%b, EVENT:%d, RESULT:%d, STATE:%d",
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

        // 4 + 5
        #4
            KEY <= 4'd4;
            EVENT <= 1;
        #2
            KEY <= 4'd0;
            EVENT <= 0;
        #4
            OP <= 0;
            EVENT <= 1;
        #2
            EVENT <= 0;
        #4
            KEY <= 4'd5;
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

        // 9 * 8
        #4
            KEY <= 4'd9;
            EVENT <= 1;
        #2
            KEY <= 4'd0;
            EVENT <= 0;
        #4
            OP <= 1;
            EVENT <= 1;
        #2
            OP <= 0;
            EVENT <= 0;
        #4
            KEY <= 4'd8;
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
            $finish;
    end

    always #1
        CLK <= ~CLK;

    calc calc_inst(CLK, KEY, OP, EQUAL, CLR, EVENT, RESULT, STATE);

endmodule