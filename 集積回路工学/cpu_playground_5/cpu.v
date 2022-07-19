module rom_8bit_16word(AD, Q);
    input [3:0] AD;
    output [7:0] Q;
    reg [7:0] q[0:15];
    assign Q = q[AD];
    
    // TODO: modify here
    initial begin
        q[4'b0000] <= 8'b00111100;
        q[4'b0001] <= 8';
        q[4'b0010] <= 8';
        q[4'b0011] <= 8';
        q[4'b0100] <= 8';
        q[4'b0101] <= 8';
        q[4'b0110] <= 8';
        q[4'b0111] <= 8';
        q[4'b1000] <= 8';
        q[4'b1001] <= 8';
        q[4'b1010] <= 8';
        q[4'b1011] <= 8';
        q[4'b1100] <= 8';
        q[4'b1101] <= 8';
        q[4'b1110] <= 8';
        q[4'b1111] <= 8';
    end
endmodule

module programCounter(CK, LD_PC, AD, OUT);
    input CK, LD_PC;
    input [3:0] AD;
    output [3:0] OUT;
    reg [3:0] q;
    initial q <= 4'd0;

    always @(posedge CK)
        q <= (LD_PC) ? AD : q + 4'd1;

    assign OUT = q;
endmodule

module register(CK, LD, BUS,
OUT);
    input CK, LD;
    input [3:0] BUS;
    output [3:0] OUT;
    reg [3:0] q;
    initial q <= 4'd0;

    always @(posedge CK)
        if(LD)
            q <= BUS;

    assign OUT = q;
endmodule

module selector(C0, C1, C2, C3,
S, Y);
    input [1:0] S;
    input [3:0] C0, C1, C2, C3;
    output [3:0] Y;

    assign Y = (S == 2'd0) ? C0 :
        (S == 2'd1) ? C1 :
        (S == 2'd2) ? C2 : C3;
endmodule

module registers(CK, LD_A, LD_B, LD_out, BUS,
A_out, B_out, O_out);
    input CK, LD_A, LD_B, LD_out;
    input [3:0] BUS;
    output [3:0] A_out, B_out, O_out;

    register A_register (CK, LD_A, BUS, A_out);
    register B_register (CK, LD_B, BUS, B_out);
    register output_register (CK, LD_out, BUS, O_out);
endmodule

module adder_4bit(Y, IM, BUS, cFlag);
    input [3:0] Y, IM;
    output [3:0] BUS;
    output cFlag;
    wire [4:0] add;

    assign add = Y + IM;
    assign BUS = add[3:0];
    assign cFlag = (add > 4'd15) ? 1'b1 : 1'b0;
endmodule

module decoder(LD_A, LD_B, LD_out, LD_PC, S, OP, Dcf);
    output LD_A, LD_B, LD_out, LD_PC;
    output [1:0] S;
    input [3:0] OP;
    input Dcf;
    reg [5:0] mem[0:25];

    assign LD_A = mem[{OP,Dcf}] >> 5;
    assign LD_B = mem[{OP,Dcf}] >> 4;
    assign LD_out = mem[{OP,Dcf}] >> 3;
    assign LD_PC = mem[{OP,Dcf}] >> 2;
    assign S = mem[{OP,Dcf}];

    // Micro Program
    initial begin
        mem[{5'b00000}] <= 6'b000000;
        mem[{5'b00001}] <= 6'b000000;
        mem[{5'b00010}] <= 6'b100000;
        mem[{5'b00011}] <= 6'b100000;
        mem[{5'b00100}] <= 6'b100001;
        mem[{5'b00101}] <= 6'b100001;
        mem[{5'b00110}] <= 6'b100010;
        mem[{5'b00111}] <= 6'b100010;
        mem[{5'b01000}] <= 6'b100011;
        mem[{5'b01001}] <= 6'b100011;
        mem[{5'b01010}] <= 6'b010000;
        mem[{5'b01011}] <= 6'b010000;
        mem[{5'b01100}] <= 6'b010001;
        mem[{5'b01101}] <= 6'b010001;
        mem[{5'b01110}] <= 6'b010010;
        mem[{5'b01111}] <= 6'b010010;
        mem[{5'b10000}] <= 6'b010011;
        mem[{5'b10001}] <= 6'b010011;
        mem[{5'b10010}] <= 6'b001001;
        mem[{5'b10011}] <= 6'b001001;
        mem[{5'b10100}] <= 6'b001011;
        mem[{5'b10101}] <= 6'b001011;
        mem[{5'b10110}] <= 6'b000111;
        mem[{5'b10111}] <= 6'b000111;
        mem[{5'b11000}] <= 6'b000111;
        mem[{5'b11001}] <= 6'b000000;
    end
endmodule

module testbench;
    wire [3:0] IM, OP, Aout, Bout, Oout, BUS, Y, address;
    wire LD_A, LD_B, LD_out, LD_PC;
    wire [7:0] op_im;
    wire [1:0] S;
    wire cFlag;
    reg CK;

    // pipeline registers
    reg [3:0] IF_OPreg, IF_IMreg, ID_IMreg, EX_BUSreg;
    reg ID_LDAreg, ID_LDBreg, ID_LDoutreg, ID_LDPCreg, EX_LDAreg, EX_LDBreg, EX_LDoutreg, EX_LDPCreg;
    reg [1:0] ID_Sreg;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, testbench);

        CK <= 0;

        // init pipeline registers IF_OPreg <= 0;
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

        #80000 sh;
    end

    always #1
        CK <= ~CK;

    rom_8bit_16word memory(address, op_im);
    assign IM = op_im; // neglect the top 4 bits
    assign OP = (op_im >> 4);
    decoder decoder(LD_A, LD_B, LD_out, LD_PC, S, IF_OPreg, cFlag);
    selector selector(Aout, Bout, 4'b0101, 4'b000, ID_Sreg,Y);
    adder_4bit alu (Y, ID_IMreg, BUS, cFlag);
    registers registers(CK, EX_LDAreg, EX_LDBreg, EX_LDoutreg, EX_BUSreg,Aout, Bout, Oout);
    programCounter programCounter(CK, EX_LDPCreg, EX_BUSreg, address);

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
endmodule