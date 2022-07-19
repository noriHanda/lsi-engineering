`timescale 100ms/100ms

module testbench;
    reg CLK, RST_N;
    reg ENTER, PAUSE;
    wire [3:0] LED;
    wire [2:0] STATE;
    wire PSTATE;
    wire [5:0] COUNT;

    initial
    begin
        $dumpfile("timer.vcd");
        $dumpvars(0, testbench);
        $monitor("CLK:%b RST_N:%b ENTER:%b, PAUSE:%b, LED:%b, COUNT:%d, STATE:%d, PSTATE:%b", 
                  CLK, RST_N, ENTER, PAUSE, LED, COUNT, STATE, PSTATE);
        CLK <= 0;
        RST_N <= 0;
        ENTER <= 0;
        PAUSE <= 0;

        #10      
            RST_N <= 1;

        #20
            ENTER <= 1;
        #10
            ENTER <= 0;

        #490
            PAUSE <= 1;
        #10
            PAUSE <= 0;

        #90
            PAUSE <= 1;
        #10
            PAUSE <= 0;

        #1840
            $finish;
    end

    always #5
        CLK <= ~CLK;

    timer timer_inst(CLK, RST_N, ENTER, PAUSE, LED, COUNT, STATE, PSTATE);

endmodule