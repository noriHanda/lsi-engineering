module testbench_cpu8;
	reg CK;
	wire [6:0] LD;
	wire [4:0] OP;
	wire [7:0] IM, Aout, Bout, Cout, Dout, Oout, BUS, Y, DMout, ADDR, ALU_IN;
	wire [12:0] IMout;
	wire cFlag, Dcflag;
	wire [2:0] SEL;
	wire key_event;

	reg [7:0] in;

	initial begin
		$dumpfile("cpu.vcd");
		$dumpvars(0, testbench_cpu8);

		CK <= 0;
		in <= 0;

		#4
			in <= 12;// push "12" key
		#5
			in <= 0;// release "12" key
		#16
			in <= 4;// push "4" key
		#6
			in <= 0;// release "4" key

		#3000
			$finish;
	end

	always #1
		CK <= ~CK;

	assign key_event = (in > 0) ? 1'b1 : 1'b0;// keypad
	registers registers(Aout, Bout, Cout, Dout, Oout, CK, LD, BUS);
	sel1 selector1(Y, SEL, Aout, Bout, in, 8'd0);
	alu alu(BUS, cFlag, Y, ALU_IN);
	dm data_memory(DMout, Cout, BUS, LD[3], CK);
	lut lut(LD, SEL, Dcflag, OP);
	im instruction_memory(IMout, ADDR);
	assign IM = IMout;// neglect the top 5 bits (OP)
	assign OP = (IMout >> 8);
	sel2 selector2(ALU_IN, SEL, IM, DMout);
	dff dff(cFlag, CK, Dcflag);
	program_counter_8b program_counter(ADDR, CK, LD[6], BUS, key_event, Dout);
endmodule