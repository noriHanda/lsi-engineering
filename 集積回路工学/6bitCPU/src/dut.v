module adder_6bit(Y, IM, BUS, cFlag);
    input [5:0] Y, IM;
    output [5:0] BUS;
    output cFlag;
    wire [6:0] add;

    assign add = Y + IM;
    assign BUS = add[5:0];
    assign cFlag = add[6];
endmodule

module programCounter(CK, LD_PC, AD, OUT);
	input CK, LD_PC;
    input [5:0] AD;
    output [5:0] OUT;
    reg [5:0] q;
    initial q <= 6'd0;

    always @(posedge CK)
        q <= (LD_PC) ? AD : q + 6'd1;

    assign OUT = q;
endmodule

module register(CK, LD, BUS, OUT);
	input CK, LD;
    input [5:0] BUS;
    output [5:0] OUT;
    reg [5:0] q;
    initial q <= 6'd0;

    always @(posedge CK)
        if(LD)
            q <= BUS;

    assign OUT = q;
endmodule

module selector(C0, C1, C2, C3, S, Y);
	input [1:0] S;
    input [5:0] C0, C1, C2, C3;
    output [5:0] Y;

    assign Y = (S == 2'd0) ? C0 :
        (S == 2'd1) ? C1 :
        (S == 2'd2) ? C2 : C3;
endmodule

module registers(CK, LD_A, LD_B, LD_out, BUS, A_out, B_out, O_out);
	input CK, LD_A, LD_B, LD_out;
    input [5:0] BUS;
    output [5:0] A_out, B_out, O_out;

    register A_register (CK, LD_A, BUS, A_out);
    register B_register (CK, LD_B, BUS, B_out);
    register output_register (CK, LD_out, BUS, O_out);
endmodule

module decoder(LD_A, LD_B, LD_out, LD_PC, S, OP, Dcf);
	output LD_A, LD_B, LD_out, LD_PC;
	output [1:0] S;
	input [3:0] OP;
	input Dcf;

	reg [5:0] mem [0:26];

	assign LD_A = mem[{OP, Dcf}] >> 5;
	assign LD_B = mem[{OP, Dcf}] >> 4;
	assign LD_out = mem[{OP, Dcf}] >> 3;
	assign LD_PC = mem[{OP, Dcf}] >> 2;
	assign S = mem[{OP, Dcf}];

	// Micro Program
	initial begin
		mem[{4'b0000,1'b0}] <= {4'b0000, 2'b00};// NOP
		mem[{4'b0000,1'b1}] <= {4'b0000, 2'b00};
		mem[{4'b0001,1'b0}] <= {4'b1000, 2'b00};// ADD A, IM
		mem[{4'b0001,1'b1}] <= {4'b1000, 2'b00};
		mem[{4'b0010,1'b0}] <= {4'b1000, 2'b01};// MOV A, B + IM
		mem[{4'b0010,1'b1}] <= {4'b1000, 2'b01};
		mem[{4'b0011,1'b0}] <= {4'b1000, 2'b10};// IN A, in + IM
		mem[{4'b0011,1'b1}] <= {4'b1000, 2'b10};
		mem[{4'b0100,1'b0}] <= {4'b1000, 2'b11};// MOV A, IM
		mem[{4'b0100,1'b1}] <= {4'b1000, 2'b11};
		mem[{4'b0101,1'b0}] <= {4'b0100, 2'b00};// MOV B, A + IM
		mem[{4'b0101,1'b1}] <= {4'b0100, 2'b00};
		mem[{4'b0110,1'b0}] <= {4'b0100, 2'b01};// ADD B, IM
		mem[{4'b0110,1'b1}] <= {4'b0100, 2'b01};
		mem[{4'b0111,1'b0}] <= {4'b0100, 2'b10};// IN B, in + IM
		mem[{4'b0111,1'b1}] <= {4'b0100, 2'b10};
		mem[{4'b1000,1'b0}] <= {4'b0100, 2'b11};// MOV B, IM
		mem[{4'b1000,1'b1}] <= {4'b0100, 2'b11};
		mem[{4'b1001,1'b0}] <= {4'b0010, 2'b01};// OUT B + IM
		mem[{4'b1001,1'b1}] <= {4'b0010, 2'b01};
		mem[{4'b1010,1'b0}] <= {4'b0010, 2'b11};// OUT IM
		mem[{4'b1010,1'b1}] <= {4'b0010, 2'b11};
		mem[{4'b1011,1'b0}] <= {4'b0001, 2'b11};// JMP IM
		mem[{4'b1011,1'b1}] <= {4'b0001, 2'b11};
		mem[{4'b1100,1'b0}] <= {4'b0001, 2'b11};// JNC IM (JMP)
		mem[{4'b1100,1'b1}] <= {4'b0000, 2'b00};// JNC IM (NOP)
	end
endmodule

module ToyCPU_6bit(CK, in, Oout);
	input CK;
	input [5:0] in;
	output [5:0] Oout;

	wire [3:0] OP;
	wire [5:0] IM, Aout, Bout, BUS, Y, address;
	wire LD_A, LD_B, LD_out, LD_PC;
	wire [9:0] op_im;
	wire [1:0] S;
	wire cFlag;

	// pipeline registers
	reg [5:0] IF_IMreg, ID_IMreg, EX_BUSreg;
	reg [3:0] IF_OPreg;
	reg ID_LDAreg, ID_LDBreg, ID_LDoutreg, ID_LDPCreg, EX_LDAreg, EX_LDBreg, EX_LDoutreg, EX_LDPCreg;
	reg [1:0] ID_Sreg;

	// init pipeline registers
	initial begin
		IF_OPreg <= 0;
		IF_IMreg <= 0;
		ID_IMreg <= 0;
		EX_BUSreg <= 0;
		ID_Sreg <= 0;
		ID_LDAreg <= 0;
		ID_LDBreg <= 0;
		ID_LDoutreg <= 0;
		ID_LDPCreg <= 0;
		EX_LDAreg <= 0;
		EX_LDBreg <= 0;
		EX_LDoutreg <= 0;
		EX_LDPCreg <= 0;
	end

	// pipeline register update
	always @(posedge CK) begin
		IF_OPreg <= OP;
		IF_IMreg <= IM;
		ID_LDAreg <= LD_A;
		ID_LDBreg <= LD_B;
		ID_LDoutreg <= LD_out;
		ID_LDPCreg <= LD_PC;
		ID_Sreg <= S;
		ID_IMreg <= IF_IMreg;
		EX_BUSreg <= BUS;
		EX_LDAreg <= ID_LDAreg;
		EX_LDBreg <= ID_LDBreg;
		EX_LDoutreg <= ID_LDoutreg;
		EX_LDPCreg <= ID_LDPCreg;
	end

	rom_10bit_64word memory(address, op_im);

	assign IM = op_im; // neglect the top 6bits
	assign OP = (op_im >> 6);

	decoder decoder(LD_A, LD_B, LD_out, LD_PC, S, IF_OPreg, cFlag);
	selector selector(Aout, Bout, in, 6'd0, ID_Sreg, Y);
	adder_6bit alu(Y, ID_IMreg, BUS, cFlag);
	registers registers(CK, EX_LDAreg, EX_LDBreg, EX_LDoutreg, EX_BUSreg, Aout, Bout, Oout);
	programCounter programCounter(CK, EX_LDPCreg, EX_BUSreg, address);
endmodule