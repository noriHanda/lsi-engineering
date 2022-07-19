module led_flash(CLK,
                 RST_N,
                 KEY,
                 SEL,
                 LED,
                 STATE);
    input CLK, RST_N, KEY, SEL;
    output LED;
    output [1:0] STATE;
    
    reg led;
    reg [1:0] state;
    
    always @(posedge CLK) begin
        if (!RST_N) begin
            state <= 2'd0;
        end else begin
            if (state == 2'd0) begin
                state <= (KEY == 1'b1 && SEL == 1'b0) ? 2'd1
                       : (KEY == 1'b1 && SEL == 1'b1) ? 2'd2
                       : state;
                led <= 1'b0;
            end else if (state == 2'd1) begin
                state <= (KEY == 1'b1) ? 2'd0 
                       : (KEY == 1'b0 && SEL == 1) ? 2'd2
                       : state;
                led <= (led == 1'b1) ? 1'b0 : 1'b1;
            end else if (state == 2'd2) begin
                state <= (KEY == 1'b1) ? 2'd0
                       : (KEY == 1'b0 && SEL == 0) ? 2'd1
                       : state;
                led <= 1'b1;
            end
        end
    end

    assign LED = led;
    assign STATE = state;
    
endmodule
