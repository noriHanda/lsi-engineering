module adv_calc(CLK, CLR, KEY, OP, EQUAL, EVENT, RESULT, STATE);
    input CLK, CLR;
    input [3:0] KEY;
    input OP;
    input EQUAL, EVENT;
    output [15:0] RESULT;
    output [2:0] STATE;

    reg [7:0] value1, value2;
    reg op;
    reg [15:0] result;
    reg [2:0] state;









endmodule