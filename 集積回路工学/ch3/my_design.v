module my_design(F,A,B,C);
	input A,B,C;
	output F;
	wire w1,w2,w3,w4;
	assign w2 = A & C;
	assign w3 = w1 & B;
	assign w4 = A & B;
	assign w1 = ~C;
	assign F = w2 | w3 | w4;
endmodule

module testbench;
	reg a,b,c;
	wire f;

	initial
	begin
		$dumpfile("my_design.vcd");
		$dumpvars(0, testbench);

		$monitor("%t: a:%b b:%b c:%b f:%b", $time, a, b, c, f);
		a <= 0;
		b <= 0;
		c <= 0;
		#8
			$finish;
	end

	always #1
		a <= ~a;
	always #2
		b <= ~b;
	always #4
		c <= ~c;
	my_design inst0 (f,a,b,c);
endmodule