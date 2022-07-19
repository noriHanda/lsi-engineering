`include "dec_7seg.v"

module accumulator(CLK, RST_N, B, LEDB, LEDC, HEXB1, HEXB0, HEXA1, HEXA0);
	input CLK;// 50MHz
	input RST_N;
	input [3:0] B;
	output [3:0] LEDB;
	output LEDC;
	output [6:0] HEXB1, HEXB0, HEXA1, HEXA0;

	parameter cnt = 100000000;
	reg [3:0] A;
	reg [26:0] counter;
	reg ledc;
	wire [3:0] S, B1, B0, A1, A0;

	always @(posedge CLK) begin
		if(!RST_N) begin
			counter <= 0;
			ledc <= 1'b0;
		end else begin
			if (counter >= cnt - 1) begin
				ledc <= !ledc;
				counter <= 0;
				if (!ledc) begin 
					A <= S + B;
				end
			end	else begin
				counter <= counter + 1;
			end
		end
	end

	assign S = A;
	assign LEDB = B;
	assign LEDC = ledc;
	assign B1 = (B >= 10) ? 1 : 1'd0;
	assign B0 = (B >= 10) ? (B - 10) : B;
	assign A1 = (A >= 10) ? 1 : 1'd0;
	assign A0 = (A >= 10) ? (A - 10) : A;

	dec_7seg dec_B1(B1, HEXB1);
	dec_7seg dec_B0(B0, HEXB0);
	dec_7seg dec_A1(A1, HEXA1);
	dec_7seg dec_A0(A0, HEXA0);
endmodule