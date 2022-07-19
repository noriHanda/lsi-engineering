module testbench;
	reg CK;
	reg [5:0] in;
	wire [5:0] Oout;

	initial begin
		$dumpfile("cpu.vcd");
		$dumpvars(0, testbench);
		CK <= 0;
		in <= 5;

		#50
			$finish;
	end

	always #1
		CK <= ~CK;

	ToyCPU_6bit ToyCPU_6bit(CK, in, Oout);
endmodule