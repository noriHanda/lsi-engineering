module led_ex(CLK, RST_N, KEY, LED, STATE);
    input CLK, RST_N, KEY;
    output LED;
    output STATE;

    reg led;
    reg state;

    always @(posedge CLK) begin
        if(!RST_N) begin
            state <= 1'd0;
        end else begin
            if(state == 1'd0) begin 
                state <= (KEY == 1'b1) ? 1'd1 : state;
                led <= 1'b0;
            end else if(state == 2'd1) begin
                state <= (KEY == 1'b1) ? 1'd0 : state;
                led <= 1'b1;
            end
        end
    end

    assign LED = led;
    assign STATE = state;

endmodule