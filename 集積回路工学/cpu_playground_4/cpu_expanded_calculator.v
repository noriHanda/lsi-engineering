// Instruction Memory
module im(dout, addr);
    output [12:0] dout;
    input [7:0] addr;
    
    reg [12:0] mem[0:255];
    
    initial
    begin
        mem[0]   <= {5'b01000, 8'd0};
        mem[1]   <= {5'b10000, 8'd3};
        mem[2]   <= {5'b01111, 8'd2};
        mem[3]   <= {5'b10000, 8'd0};
        mem[4]   <= {5'b00010, 8'd0};
        mem[5]   <= {5'b01001, 8'd0};
        mem[6]   <= {5'b10000, 8'd8};
        mem[7]   <= {5'b01111, 8'd7};
        mem[8]   <= {5'b10000, 8'd0};
        mem[9]   <= {5'b00010, 8'd0};
        mem[10]  <= {5'b01011, 8'd0};
        mem[11]  <= {5'b00100, 8'd0};
        mem[12]  <= {5'b01100, 8'd0};
        mem[13]  <= {5'b01111, 8'd13};
    end
    
    assign dout = mem[addr];
endmodule

// Data Memory
module dm(dout, addr, BUS, LD, CK);
    output [7:0] dout;
    input [7:0] addr, BUS;
    input LD;
    input CK;
    reg [7:0] mem[0:255];
    integer i;
    initial
        for(i = 0; i < 256; i = i + 1)
            mem[i] <= 8'd0;

    always @(posedge CK)
        if (LD)
            mem[addr] <= BUS;
                    
    assign dout = mem[addr];
endmodule

// Lookup Table (decoder)
module lut(LD, SEL, cFlag, OP);
    output [6:0] LD;
    output [2:0] SEL;
    input [4:0] OP;
    input cFlag;

    reg [9:0] mem[0:63];

    assign SEL = mem[{OP,cFlag}];
    assign LD  = mem[{OP,cFlag}] >> 3;

    initial
    begin
        //     OP4-0 cFlag     LD6-0       SEL2-0
        mem[{6'b000000}] <= {7'b0000001, 3'b000}; // ADD A, Im
        mem[{6'b000001}] <= {7'b0000001, 3'b000};
        mem[{6'b000010}] <= {7'b0000001, 3'b001}; // MOV A, B+Im
        mem[{6'b000011}] <= {7'b0000001, 3'b001};
        mem[{6'b000100}] <= {7'b0000001, 3'b010}; // IN A, in+Im
        mem[{6'b000101}] <= {7'b0000001, 3'b010};
        mem[{6'b000110}] <= {7'b0000001, 3'b011}; // MOV A, Im
        mem[{6'b000111}] <= {7'b0000001, 3'b011};
        mem[{6'b001000}] <= {7'b0000010, 3'b000}; // MOV B, A+Im
        mem[{6'b001001}] <= {7'b0000010, 3'b000};
        mem[{6'b001010}] <= {7'b0000010, 3'b001}; // ADD B, Im
        mem[{6'b001011}] <= {7'b0000010, 3'b001};
        mem[{6'b001100}] <= {7'b0000010, 3'b010}; // IN B, in+Im
        mem[{6'b001101}] <= {7'b0000010, 3'b010};
        mem[{6'b001110}] <= {7'b0000010, 3'b011}; // MOV B, Im
        mem[{6'b001111}] <= {7'b0000010, 3'b011};
        mem[{6'b010000}] <= {7'b0000100, 3'b011}; // MOV C, Im
        mem[{6'b010001}] <= {7'b0000100, 3'b011};
        mem[{6'b010010}] <= {7'b0001000, 3'b000}; // MOV R[C], A+Im
        mem[{6'b010011}] <= {7'b0001000, 3'b000};
        mem[{6'b010100}] <= {7'b0000001, 3'b111}; // MOV A, R[C]
        mem[{6'b010101}] <= {7'b0000001, 3'b111};
        mem[{6'b010110}] <= {7'b0000001, 3'b100}; // ADD A, R[C]
        mem[{6'b010111}] <= {7'b0000001, 3'b100};
        mem[{6'b011000}] <= {7'b0010000, 3'b001}; // OUT B+Im
        mem[{6'b011001}] <= {7'b0010000, 3'b001};
        mem[{6'b011010}] <= {7'b0010000, 3'b011}; // OUT Im
        mem[{6'b011011}] <= {7'b0010000, 3'b011};
        mem[{6'b011100}] <= {7'b1000000, 3'b011}; // JNC Im
        mem[{6'b011101}] <= {7'b0000000, 3'b000}; // NOP
        mem[{6'b011110}] <= {7'b1000000, 3'b011}; // JMP Im
        mem[{6'b011111}] <= {7'b1000000, 3'b011};
        mem[{6'b100000}] <= {7'b0100000, 3'b011}; // MOV D, Im
        mem[{6'b100001}] <= {7'b0100000, 3'b011};
    end
endmodule

module program_counter_8b(AD, CK, LD, ADR, EVENT, VEC);
    output [7:0] AD;
    input [7:0] ADR, VEC;
    input CK, EVENT;
    input LD;

    reg [7:0] Q;

    initial
        Q <= 0;
    
    always @(posedge CK or posedge EVENT)
        if(EVENT && VEC != 8'd0)
            Q <= VEC;
        else
            Q <= (LD) ? ADR : Q + 8'd1;

    assign AD = Q;
endmodule

module register_8b(QOUT, CK, LD, BUS);
    output [7:0] QOUT;
    input [7:0] BUS;
    input CK, LD;
    reg [7:0] Q;

    initial
        Q <= 8'd0;

    always @(posedge CK)
        if(LD)
            Q <= BUS;

    assign QOUT = Q;
endmodule

module registers(Aout, Bout, Cout, Dout, Oout, CK, LD, BUS);
    output [7:0] Aout, Bout, Cout, Dout, Oout;
    input [7:0] BUS;
    input [6:0] LD;

    input CK;

    register_8b Areg (Aout, CK, LD[0], BUS);
    register_8b Breg (Bout, CK, LD[1], BUS);
    register_8b Creg (Cout, CK, LD[2], BUS);
    register_8b Dreg (Dout, CK, LD[5], BUS);
    register_8b Oreg (Oout, CK, LD[4], BUS);
endmodule

module sel1(Y, SEL, C0, C1, C2, C3);
    output [7:0] Y;
    input [7:0] C0, C1, C2, C3;
    input [2:0] SEL;
    wire [1:0] select;

    assign select = SEL;

    assign Y = (select == 2'd0) ? C0 : (select == 2'd1) ? C1 : (select == 2'd2) ? C2 : C3;
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
    assign BUS = ADD;  // connect the last 8 bits
    assign cFlag = ADD[8];
endmodule

module dff(D, CK, QOUT);
    input D, CK;
    output QOUT;
    reg Q;

    initial
        Q <= 1'b0;

    always @(posedge CK)
        Q <= D;

    assign QOUT = Q;
endmodule

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

    initial
    begin
        $monitor("%b pc:%d op:%b im:%b in:%b SEL:%b ld:%b BUS:%b A:%b B:%b C:%b D:%b O:%b C:%b DMout:%b", CK, ADDR, OP, IM, in, SEL, LD, BUS, Aout, Bout, Cout, Dout, Oout, cFlag, DMout);
        CK <= 0;
        in <= 0;
        
        #4
        in <= 2; // push "2" key
        #5
        in<=0; //release"2"key
        #16
        in<=4; // push "4" key
        #6
        in<=0; //release"4"key

        #10 $finish;
    end

    always #1
        CK <= ~CK;

    assign key_event = (in > 0) ? 1 : 0; // keypad
    registers registers (Aout, Bout, Cout, Dout, Oout, CK, LD, BUS); sel1 selector1 (Y, SEL, Aout, Bout, in, 8'd0);
    alu alu (BUS, cFlag, Y, ALU_IN);
    dm data_memory (DMout, Cout, BUS, LD[3], CK);
    lut lut (LD, SEL, Dcflag, OP);
    im instruction_memory (IMout, ADDR);
    assign IM = IMout; // neglect the top 5 bits (OP)
    assign OP = (IMout >> 8);
    sel2 selector2(ALU_IN, SEL, IM, DMout);
    dff dff(cFlag, CK, Dcflag);
    program_counter_8b program_counter (ADDR, CK, LD[6], BUS, key_event, Dout);
endmodule