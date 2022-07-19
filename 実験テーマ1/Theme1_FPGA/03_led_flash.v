module led_flash(CLK, RST_N, LED);
	input CLK;// 50MHz
	input RST_N;
	output LED;

	reg LED_025Hz; // 0.25Hz

	parameter cnt = 100000000;
	reg [26:0] counter;

	always @(posedge CLK) begin
		if (!RST_N) begin
			LED_025Hz <= 1'b0;
			counter <= 0;
		end	else begin
			if (counter >= cnt - 1) begin
				LED_025Hz <= !LED_025Hz;
				counter <= 0;
			end	else begin
				counter <= counter + 1;
			end
		end
			
	end
	
	assign LED = LED_025Hz;
endmodule