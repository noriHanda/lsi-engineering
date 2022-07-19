// Data Memory
module dm(dout, addr, BUS, LD, CK);
	output [7:0] dout;
	input [7:0] addr, BUS;
	input LD;
	input CK;
	reg [7:0] mem [0:255];
	integer i;

	initial begin
		for(i =0; i < 256; i = i + 1)
			mem[i] <= 8'd0;
	end

	always @(posedge CK) begin
		if(LD) begin
			mem[addr] <= BUS;
		end
	end

	assign dout = mem[addr];
endmodule




// Lookup Table (decoder)
module lut(LD, SEL, cFlag, OP);
	output [6:0] LD;
	output [2:0] SEL;
	input [4:0] OP;
	input cFlag;

	reg [9:0] mem [0:63];

	assign SEL = mem[{OP, cFlag}];
	assign LD = mem[{OP, cFlag}] >> 3;

	initial begin
		// 	   OP4-0   cFlag         LD6-0    SEL2-0
		mem[{5'b00000, 1'b0}] <= {7'b0000001, 3'b000};// ADD A, Im
		mem[{5'b00000, 1'b1}] <= {7'b0000001, 3'b000};
		mem[{5'b00001, 1'b0}] <= {7'b0000001, 3'b001};// MOV A, B + Im
		mem[{5'b00001, 1'b1}] <= {7'b0000001, 3'b001};
		mem[{5'b00010, 1'b0}] <= {7'b0000001, 3'b010};// IN A, in + Im
		mem[{5'b00010, 1'b1}] <= {7'b0000001, 3'b010};
		mem[{5'b00011, 1'b0}] <= {7'b0000001, 3'b011};// MOV A, Im
		mem[{5'b00011, 1'b1}] <= {7'b0000001, 3'b011};

		mem[{5'b00100, 1'b0}] <= {7'b0000010, 3'b000};// MOV B, A + Im
		mem[{5'b00100, 1'b1}] <= {7'b0000010, 3'b000};
		mem[{5'b00101, 1'b0}] <= {7'b0000010, 3'b001};// ADD B, Im
		mem[{5'b00101, 1'b1}] <= {7'b0000010, 3'b001};
		mem[{5'b00110, 1'b0}] <= {7'b0000010, 3'b010};// IN B, in + Im
		mem[{5'b00110, 1'b1}] <= {7'b0000010, 3'b010};
		mem[{5'b00111, 1'b0}] <= {7'b0000010, 3'b011};// MOV B, Im
		mem[{5'b00111, 1'b1}] <= {7'b0000010, 3'b011};

		mem[{5'b01000, 1'b0}] <= {7'b0000100, 3'b011};// MOV C, Im
		mem[{5'b01000, 1'b1}] <= {7'b0000100, 3'b011};
		mem[{5'b01001, 1'b0}] <= {7'b0001000, 3'b000};// MOV R[C], A + Im
		mem[{5'b01001, 1'b1}] <= {7'b0001000, 3'b000};
		mem[{5'b01010, 1'b0}] <= {7'b0000001, 3'b111};// MOV A, R[C]
		mem[{5'b01010, 1'b1}] <= {7'b0000001, 3'b111};
		mem[{5'b01011, 1'b0}] <= {7'b0000001, 3'b100};// ADD A, R[C]
		mem[{5'b01011, 1'b1}] <= {7'b0000001, 3'b100};

		mem[{5'b01100, 1'b0}] <= {7'b0010000, 3'b001};// OUT B + Im
		mem[{5'b01100, 1'b1}] <= {7'b0010000, 3'b001};
		mem[{5'b01101, 1'b0}] <= {7'b0010000, 3'b011};// OUT Im
		mem[{5'b01101, 1'b1}] <= {7'b0010000, 3'b011};

		mem[{5'b01110, 1'b0}] <= {7'b1000000, 3'b011};// JNC Im (JMP)
		mem[{5'b01110, 1'b1}] <= {7'b0000000, 3'b000};// JNC Im (NOP)

		mem[{5'b01111, 1'b0}] <= {7'b1000000, 3'b011};// JMP Im
		mem[{5'b01111, 1'b1}] <= {7'b1000000, 3'b011};

		mem[{5'b10000, 1'b0}] <= {7'b0100000, 3'b011};// MOV D, Im
		mem[{5'b10000, 1'b1}] <= {7'b0100000, 3'b011};
	end
endmodule




module program_counter_8b(AD, CK, LD, ADR, EVENT, VEC);
	output [7:0] AD;
	input [7:0] ADR, VEC;
	input CK, EVENT;
	input LD;

	reg [7:0] Q;

	initial begin
		Q <= 8'd0;
	end

	always @(posedge CK or posedge EVENT) begin
		if(EVENT && VEC != 8'd0) begin
			Q <= VEC;
		end else begin
			Q <= (LD) ? ADR : Q + 8'd1;
		end
	end

	assign AD = Q;
endmodule




module register_8b(QOUT, CK, LD, BUS);
	output [7:0] QOUT;
	input [7:0] BUS;
	input CK, LD;

	reg [7:0] Q;

	initial begin
		Q <= 8'd0;
	end

	always @(posedge CK) begin
		if(LD) begin
			Q <= BUS;
		end
	end

	assign QOUT = Q;
endmodule




module registers(Aout, Bout, Cout, Dout, Oout, CK, LD, BUS);
	output [7:0] Aout, Bout, Cout, Dout, Oout;
	input [7:0] BUS;
	input [6:0] LD;
	input CK;

	register_8b Areg(Aout, CK, LD[0], BUS);
	register_8b Breg(Bout, CK, LD[1], BUS);
	register_8b Creg(Cout, CK, LD[2], BUS);
	register_8b Dreg(Dout, CK, LD[5], BUS);
	register_8b Oreg(Oout, CK, LD[4], BUS);
endmodule




module sel1(Y, SEL, C0, C1, C2, C3);
	output [7:0] Y;
	input [7:0] C0, C1, C2, C3;
	input [2:0] SEL;

	wire [1:0] select;

	assign select = SEL;
	assign Y = (select == 2'd0) ? C0 :
			   (select == 2'd1) ? C1 :
			   (select == 2'd2) ? C2 : C3;
endmodule




module sel2(Y, SEL, C0, C1);
	output [7:0] Y;
	input [7:0] C0, C1;
	input [2:0] SEL;

	assign Y = (SEL[2] == 1'b0) ? C0 : C1;
endmodule




module alu(BUS, cFlag, Y, IM);
	output [7:0] BUS;
	output cFlag;
	input [7:0] Y, IM;
	wire [8:0] ADD;

	assign ADD = Y + IM;
	assign BUS = ADD;// connect the last 8 bits
	assign cFlag = ADD[8];
endmodule




module dff(D, CK, QOUT);
	input D, CK;
	output QOUT;

	reg Q;

	initial begin
		Q <= 1'd0;
	end

	always @(posedge CK) begin
		Q <= D;
	end

	assign QOUT = Q;
endmodule