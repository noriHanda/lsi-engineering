`include "dec_7seg.v"

module comparator(A, B, LEDA, LEDB, HEXA, HEXB, HEXC);
	input [3:0] A, B;
	output [3:0] LEDA, LEDB;
	output [6:0] HEXA, HEXB, HEXC;

	wire [3:0] C;

	assign C = (A > B) ? 10
				: (A < B) ? 11 : 14;
	assign LEDA = A;
	assign LEDB = B;

	dec_7seg dec_A(A, HEXA);
	dec_7seg dec_B(B, HEXB);
	dec_7seg dec_C(C, HEXC);
endmodule