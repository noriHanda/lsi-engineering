module calc(CLK, KEY, OP, EQUAL, CLR, EVENT, RESULT, STATE);
    input CLK;
    input [3:0] KEY;
    input OP, EQUAL, CLR, EVENT;
    output [7:0] RESULT;
    output [2:0] STATE;

    reg [3:0] value1, value2;
    reg op;
    reg [7:0] result;
    reg [2:0] state;

    always @(posedge CLK) begin
        if (CLR) begin
            state <= 3'd0;
            result <= 8'd0;
            op <= 0;
        end
        else begin
            case (state)
                3'd0: state <= (KEY && EVENT) ? 3'd1 : 3'd0;
                3'd1: state <= (EVENT) ? 3'd2 : 3'd1;
                3'd2: state <= (KEY && EVENT) ? 3'd3 : 3'd2;
                3'd3: state <= (EQUAL && EVENT) ? 3'd4 : 3'd3;
                3'd4: state <= (CLR && EVENT) ? 3'd0 : 3'd4;
            endcase

            value1 <= (state == 3'd0) ? KEY : value1;
            op <= (state == 3'd1) ? OP : op;
            value2 <= (state == 3'd2) ? KEY : value2;
            result <= (state == 3'd4 && op == 0) ? value1 + value2
                    : (state == 3'd4 && op == 1) ? value1 * value2
                    : RESULT;
        end
    end

    assign STATE = state;
    assign RESULT = result;

endmodule