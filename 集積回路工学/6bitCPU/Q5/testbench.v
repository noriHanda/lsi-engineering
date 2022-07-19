module testbench;
	reg CK;
	reg [5:0] in;
	wire [5:0] Oout;

	initial begin
		$dumpfile("cpu.vcd");
		$dumpvars(0, testbench);
		CK <= 0;
		in <= 0;

		#16
			in <= 2;// push "2" key

		#16
			in <= 0;// release "2" key

		#768
			in <= 4;// push "4" key

		#16
			in <= 0;// release "4" key

		#100
			$finish;
	end

	always #1
		CK <= ~CK;

	ToyCPU_6bit ToyCPU_6bit(CK, in, Oout);
endmodule