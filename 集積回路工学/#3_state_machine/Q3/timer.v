module timer(CLK, RST_N, ENTER, PAUSE, LED, COUNT, STATE, PSTATE);
    input CLK, RST_N; 
    input ENTER, PAUSE;
    output [3:0] LED;
    output [5:0] COUNT;
    output [2:0] STATE;
    output PSTATE;

    reg [2:0] state;
    reg [5:0] count;
    reg [3:0] led;
    reg pstate;








endmodule