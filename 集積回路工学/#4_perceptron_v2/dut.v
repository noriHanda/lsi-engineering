module mul1(A, B, P);
    input A;
    input [3:0] B;
    output [3:0] P;

    assign P = A * B;
endmodule

module add1(A, B, C, S);
    input [3:0] A, B, C;
    output [5:0] S;

    wire [5:0] a_ex, b_ex, c_ex;

    // Extend 4 bit inputs to 6 bits in case of negatives
    assign a_ex = (A[3] == 1) ? {2'b11, A} : {2'b00, A};
    assign b_ex = (B[3] == 1) ? {2'b11, B} : {2'b00, B};
    assign c_ex = (C[3] == 1) ? {2'b11, C} : {2'b00, C};

    // Sum up
    assign S = a_ex + b_ex + c_ex;
endmodule

module step_func(x, y);
    input [5:0] x;
    output y;

    assign y = (x[5] == 1 || x == 6'b000000) ? 1'b0 : 1'b1;
endmodule

module comp(A, B, D);
    input A, B;
    output [1:0] D;

    assign D = A - B;
endmodule 

module mul2(A, B, P);
    input A;
    input [1:0] B;
    output [1:0] P;

    assign P = (A == 1'b0) ? 0 : B;
endmodule

module add2(A, B, S);
    input [3:0] A;
    input [1:0] B;
    output [3:0] S;

    assign S = (B == 2'b01) ? A + 4'b0001
             : (B == 2'b10) ? A + 4'b1111
             : A;
endmodule

module state_machine(CLK, STATE);
    input CLK;
    output [1:0] STATE;

    reg [1:0] state;

    initial state <= 0;

    always @(posedge CLK) begin
        if (state == 2'd0) begin
            state <= 2'd1;
        end else if (state == 2'd1) begin
            state <= 2'd2;
        end else if (state == 2'd2) begin
            state <= 2'd3;
        end else if (state == 2'd3) begin
            state <= 2'd0;
        end
    end

    assign STATE = state;
endmodule

module mem(CLK, WRITE_ADDR, WRITE_DATA, READ_ADDR1, READ_ADDR2, READ_DATA1, READ_DATA2, DEBUG_OUT0, DEBUG_OUT1, DEBUG_OUT2, DEBUG_OUT3);
    input CLK;
    input [11:0] WRITE_DATA;
    input [1:0] WRITE_ADDR;
    output [11:0] READ_DATA1, READ_DATA2;
    output [11:0] DEBUG_OUT0, DEBUG_OUT1, DEBUG_OUT2, DEBUG_OUT3;
    input [1:0] READ_ADDR1, READ_ADDR2;

    reg [11:0] mem [0:3];

    initial begin
        mem[0] <= 12'b000000000000; //x1, x2, S
        mem[1] <= 12'b000000000000; //z
        mem[2] <= 12'b000000000000; //dw1, dw2, dw3(delta)
        mem[3] <= 12'b000000100001; //w1, w2, w3
    end

    always @(posedge CLK) begin
        mem[WRITE_ADDR] <= WRITE_DATA;
    end

    assign READ_DATA1 = mem[READ_ADDR1]; 
    assign READ_DATA2 = mem[READ_ADDR2];
    assign DEBUG_OUT0 = mem[0];
    assign DEBUG_OUT1 = mem[1];
    assign DEBUG_OUT2 = mem[2];
    assign DEBUG_OUT3 = mem[3];

endmodule

module mem_ctrl(STATE, WRITE_ADDR, WRITE_DATA, READ_ADDR1, READ_ADDR2, s, x1, x2, z, dw1, dw2, delta, update_w1, update_w2, update_w3);
    input [1:0] STATE;
    input s, x1, x2, z;
    input [1:0] dw1, dw2, delta;
    input [3:0] update_w1, update_w2, update_w3;
    output [1:0] WRITE_ADDR, READ_ADDR1, READ_ADDR2;
    output [11:0] WRITE_DATA;

    assign WRITE_DATA = (STATE == 0) ? {9'b0, s, x2, x1}       :
                        (STATE == 1) ? {11'b0, z}              :
                        (STATE == 2) ? {6'b0, delta, dw2, dw1} : {update_w3, update_w2, update_w1};


    assign READ_ADDR1 = (STATE == 0) ? 2'd0
                      : (STATE == 1) ? 2'd0
                      : (STATE == 2) ? 2'd0
                      : 2'd2;

    assign READ_ADDR2 = (STATE == 0) ? 2'd0
                      : (STATE == 1) ? 2'd3
                      : (STATE == 2) ? 2'd1
                      : 2'd3;

    assign WRITE_ADDR = (STATE == 0) ? 2'd0
                      : (STATE == 1) ? 2'd1
                      : (STATE == 2) ? 2'd2
                      : 2'd3;
endmodule

module perceptron(CLK, X1, X2, W1, W2, W3, Z, S, DELTA, STATE);
    input CLK;
    input X1, X2, S;
    output Z;
    output [3:0] W1, W2, W3;
    output [1:0] DELTA;
    output [1:0] STATE;

    wire [11:0] DEBUG_OUT0, DEBUG_OUT1, DEBUG_OUT2, DEBUG_OUT3;
    wire x1_m, x2_m;
    wire [3:0] x1w1, x2w2, w1_m, w2_m, w3_m, update_w1, update_w2, update_w3;
    wire [5:0] mac;
    wire z, z_m, s_m;
    wire [1:0] delta, delta_m;
    wire [1:0] dw1, dw2, dw3, dw1_m, dw2_m;
    wire [1:0] state;
    wire [11:0] write_data;
    wire [1:0] WRITE_addr;
    wire [11:0] read_data1, read_data2;
    wire [1:0] read_addr1, read_addr2;

    assign Z = z;
    assign W1 = w1_m;
    assign W2 = w2_m;
    assign W3 = w3_m;
    assign DELTA = delta;
    assign STATE = state;

    // ビット取り出し
    assign x1_m = read_data1;
    assign x2_m = read_data1 >> 1;
    assign s_m = read_data1 >> 2;

    assign w1_m = read_data2;
    assign w2_m = read_data2 >> 4;
    assign w3_m = read_data2 >> 8;

    assign z_m = read_data2;

    assign dw1_m = read_data1;
    assign dw2_m = read_data1 >> 2;
    assign delta_m = read_data1 >> 4;

    // 各モジュールインスタンス化
    state_machine sm(CLK, state);

    mem_ctrl mem_con(state, WRITE_addr, write_data, read_addr1, read_addr2, S, X1, X2, z, dw1, dw2, delta, update_w1, update_w2, update_w3);
    mem mem(CLK, WRITE_addr, write_data, read_addr1, read_addr2, read_data1, read_data2, DEBUG_OUT0, DEBUG_OUT1, DEBUG_OUT2, DEBUG_OUT3);

    // For state 1
    mul1 mul1_1(x1_m, w1_m, x1w1);
    mul2 mul1_2(x2_m, w2_m, x2w2);

    add1 add1(x1w1, x2w2, w3_m, mac);

    step_func step_func(mac, z);

    // For state 2
    comp Comp(s_m, z_m, delta);

    mul2 mul2_1(x1_m, delta, dw1);
    mul2 mul2_2(x2_m, delta, dw2);

    // For state 3
    add2 add2_1(w1_m, dw1_m, update_w1);
    add2 add2_2(w2_m, dw2_m, update_w2);
    add2 add3_2(w3_m, delta_m, update_w3);
endmodule