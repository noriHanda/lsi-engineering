`include "dec_7seg.v"

module adder(A, B, LEDA, LEDB, LEDY, HEXA, HEXB, HEXY);
	input [2:0] A, B;
	output [2:0] LEDA, LEDB;
	output [3:0] LEDY;
	output [6:0] HEXA, HEXB, HEXY;

	wire [3:0] Y;

	assign 	Y = A + B;
	assign  LEDA = A;
	assign  LEDB = B;
	assign  LEDY = Y;

	dec_7seg dec_A({1'b0, A}, HEXA);
	dec_7seg dec_B({1'b0, B}, HEXB);
	dec_7seg dec_Y(Y, HEXY);
endmodule