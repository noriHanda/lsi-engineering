module testbench_cpu8;
	reg CK;
	wire [6:0] LD;
	wire [4:0] OP;
	wire signed [7:0] IM, Aout, Bout, Cout, Dout, Oout, BUS, Y, DMout, ALU_IN;
	wire [7:0] ADDR;
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

		#6
			in <= 20;
		#6
			in <= 40;
		#6
			in <= 60;
		#6
			in <= 80;
		#6
			in <= 100;
		#6
			in <= 110;
		#6
			in <= 90;
		#6
			in <= 70;
		#6
			in <= 50;
		#6
			in <= 30;
		#6
			in <= 20;
		#6
			in <= 35;
		#6
			in <= 45;
		#6
			in <= 55;
		#6
			in <= 50;

		#10
			$finish;
	end

	always #1
		CK <= ~CK;

	assign key_event = 1'b0;// keypad
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