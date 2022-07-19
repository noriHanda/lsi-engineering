module testbench;
    reg CLK;
    reg [1:0] STATE;
    reg s, x1, x2, z;
    reg [1:0] dw1, dw2, delta;
    reg [3:0] update_w1, update_w2, update_w3;
    wire [1:0] WRITE_ADDR, READ_ADDR1, READ_ADDR2;
    wire [11:0] WRITE_DATA;
    wire [11:0] READ_DATA1, READ_DATA2;
    wire [11:0] DEBUG_OUT0, DEBUG_OUT1, DEBUG_OUT2, DEBUG_OUT3;

    initial
    begin
        $dumpfile("mem_ctrl_test.vcd");
        $dumpvars(0, testbench);

        CLK <= 0;
        STATE <= 0;
        s <= 1;
        x1 <= 1;
        x2 <= 1;
        z <= 0;
        dw1 <= 0;
        dw2 <= 0;
        delta <= 0;
        update_w1 <= 0;
        update_w2 <= 0;
        update_w3 <= 0;

        #2  // STATE 1
            s <= 0;
            x1 <= 0;
            x2 <= 0;
            z <= 1;
        
        #2  // STATE 2
            z <= 0;
            dw1 <= 2'b01;
            dw2 <= 2'b10;
            delta <= 2'b11;

        #2 // STATE 3
            dw1 <= 2'b00;
            dw2 <= 2'b00;
            delta <= 2'b00;
            update_w1 <= 4'b0101;
            update_w2 <= 4'b1010;
            update_w3 <= 4'b1111;

        #2 // STATE 0
            update_w1 <= 0;
            update_w2 <= 0;
            update_w3 <= 0;
            s <= 0;
            x1 <= 0;
            x2 <= 1;

        #2  // STATE 1
            s <= 0;
            x1 <= 0;
            x2 <= 0;
            z <= 0;
        
        #2  // STATE 2
            z <= 0;
            dw1 <= 2'b10;
            dw2 <= 2'b11;
            delta <= 2'b00;

        #2 // STATE 3
            dw1 <= 2'b00;
            dw2 <= 2'b00;
            delta <= 2'b00;
            update_w1 <= 4'b1100;
            update_w2 <= 4'b0011;
            update_w3 <= 4'b1001;

        #2 // STATE 0
            update_w1 <= 0;
            update_w2 <= 0;
            update_w3 <= 0;

        #2
            $finish;
    end

    always #1 CLK <= !CLK;
    always #2 STATE <= STATE + 1;


    mem mem(CLK, WRITE_ADDR, WRITE_DATA, READ_ADDR1, READ_ADDR2, READ_DATA1, READ_DATA2, DEBUG_OUT0, DEBUG_OUT1, DEBUG_OUT2, DEBUG_OUT3);
    mem_ctrl mem_ctrl(STATE, WRITE_ADDR, WRITE_DATA, READ_ADDR1, READ_ADDR2, s, x1, x2, z, dw1, dw2, delta, update_w1, update_w2, update_w3);
endmodule