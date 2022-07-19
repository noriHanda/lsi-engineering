module my_design_practice (A, B, C, F);
    input  A, B, C;
    wire w1, w2, w3, w4;
    output F;
    assign w1 = ~C;
    assign w2 = A & C;
    assign w3 = w1 & B;
    assign w4 = B & A;
    assign F = w2 | w3 | w4;
endmodule

module testbench;
	reg a,b,c;
	wire f;

	initial
	begin
		$dumpfile("my_design_practice.vcd");
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
	my_design_practice inst0 (a,b,c,f);
endmodule