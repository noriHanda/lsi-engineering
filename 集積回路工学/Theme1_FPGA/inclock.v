`include "hex_ctrl.v"

module inclock(CLK, NO, STOP, START, RST_N, DISPLAY, DEBUG, LEDR, LEDG, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input CLK;// 50MHz
	input [3:0] NO;
	input STOP, START, RST_N;
	input DISPLAY, DEBUG;
	output [17:0] LEDR;
	output [8:0] LEDG;
	output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

	// Please write down your code!
	reg [1:0] state;// ステート
	reg [3:0] target;// 目標値の秒数
	reg [25:0] counter;// 10ミリ秒を数えるカウンタ
	reg [4:0] count_sec;// 秒を計測するカウンタ
	reg [6:0] count_10msec;// 10ミリ秒を計測するカウンタ
	reg [25:0] led_counter;// LEDRを制御するためのカウンタ
	reg [17:0] ledr;// LEDRを制御するためのレジスタ

	wire [1:0] result;// 計測結果の判定結果 0: JUSt ピッタリ, 1: gOOd ±0.1秒, 2: SOSO ±0.2秒, 3: bAd それ以外
	wire [2:0] debug;

	parameter cnt_1sec = /* Count */;// 10ミリ秒が何個で1秒?
	parameter cnt_10msec = /* Count */;// 20ナノ秒が何個で10ミリ秒?
	parameter cnt_res0 = 19'd500000;
	parameter cnt_led = 26'd50000000;

	always @(posedge CLK) begin
		if(!RST_N) begin
			state <= 0;
			target <= 0;
			counter <= 0;
			count_sec <= 0;
			count_10msec <= 0;
			led_counter <= 0;
			ledr <= 0;
		end else begin
			if(state == 2'd0) begin // input wait
				if(NO == 4'd0) begin
					/*

					Please write down your code!

					*/
				end else begin
					target <= NO;
				end

				if(/* Please write down your code! */) begin
					state <= 2'd1;
					ledr <= {{15{1'b0}}, {3{1'b1}}};
				end
			end else if(state == 2'd1) begin // count down
				if(ledr == 18'd0) begin
					state <= 2'd2;
				end else begin
					if(led_counter >= cnt_led - 1'b1) begin
						ledr <= {ledr[17:3], ledr[1:0], 1'b0};
						led_counter <= 0;
					end else begin
						led_counter <= led_counter + 1'b1;
					end
				end
			end else if(state == 2'd2) begin // time measure
				if(/* Please write down your code! */) begin
					state <= 2'd3;
					ledr <= {1'b1, {17{1'b0}}};
				end else begin
					if(counter >= (cnt_10msec << debug) - 1'b1) begin
						/*

						Please write down your code!

						*/
					end else begin
						counter <= counter + 1'b1;
					end
				end
			end else if(state == 2'd3) begin // result
				if(STOP == 0 || START == 0) begin
					state <= 0;
					target <= 0;
					counter <= 0;
					count_sec <= 0;
					count_10msec <= 0;
					led_counter <= 0;
					ledr <= 0;
				end else begin
					if(led_counter >= (cnt_res0 << result) - 1'b1) begin
						led_counter <= 0;
						ledr <= {ledr[0], ledr[17:1]};
					end else begin
						led_counter <= led_counter + 1'b1;
					end
				end
			end
		end
	end

	assign debug = (DEBUG) ? 3'd5 : 3'd0;

	// 計測結果の判定 0: ピッタリ, 1: ±0.1秒, 2: ±0.2秒, 3: それ以外
	assign result = (/* Please write down your code! */) ? 2'd0 : 
				    (/* Please write down your code! */) ? 2'd1 : 
				    (/* Please write down your code! */) ? 2'd2 : 2'd3;

	assign LEDR = ledr;
	assign LEDG = {{7{1'b0}}, state};

	hex_ctrl hex_gen(state, target, count_sec, count_10msec, result, DISPLAY, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
endmodule