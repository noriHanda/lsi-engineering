`include "dec_7seg.v"

module shift_reg(CLK, RST_N, D, LEDD, LEDC, HEXq7, HEXq6, HEXq5, HEXq4, HEXq3, HEXq2, HEXq1, HEXq0);
	input CLK;// 50MHz
	input RST_N;
	input [3:0] D;
	output [3:0] LEDD;
	output LEDC;
	output [6:0] HEXq7, HEXq6, HEXq5, HEXq4, HEXq3, HEXq2, HEXq1, HEXq0;

	parameter cnt = 100000000;
	reg [3:0] q7, q6, q5, q4, q3, q2, q1, q0;
	reg [26:0] counter;
	reg ledc;

	always @(posedge CLK) begin
		if(!RST_N) begin
			q7 <= 4'h0;
			q6 <= 4'h0;
			q5 <= 4'h0;
			q4 <= 4'h0;
			q3 <= 4'h0;
			q2 <= 4'h0;
			q1 <= 4'h0;
			q0 <= 4'h0;
			counter <= 0;
			ledc <= 1'b0;
		end else begin
			if (counter >= cnt - 1) begin
				ledc <= !ledc;
				counter <= 0;
				if (!ledc) begin 
					q7 <= D;
					q6 <= q7;
					q5 <= q6;
					q4 <= q5;
					q3 <= q4;
					q2 <= q3;
					q1 <= q2;
					q0 <= q1;
				end
			end	else begin
				counter <= counter + 1;
			end
		end
	end

	dec_7seg dec_q7(q7, HEXq7);
	dec_7seg dec_q6(q6, HEXq6);
	dec_7seg dec_q5(q5, HEXq5);
	dec_7seg dec_q4(q4, HEXq4);
	dec_7seg dec_q3(q3, HEXq3);
	dec_7seg dec_q2(q2, HEXq2);
	dec_7seg dec_q1(q1, HEXq1);
	dec_7seg dec_q0(q0, HEXq0);

	assign LEDD = D;
	assign LEDC = ledc;
endmodule