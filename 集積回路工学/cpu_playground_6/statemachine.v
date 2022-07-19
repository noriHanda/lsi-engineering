module register_3bit (RST,
                      CLK,
                      LD,
                      D,
                      Q);
    input CLK, RST, LD;
    input [2:0] D;
    output [2:0] Q;
    reg [2:0] q;
    
    always @(posedge CLK)
        q <= (RST) ? 3'd0 : (LD) ? D : q;
    
    assign Q = q;
endmodule
    
module alu(A, B, Y);
    input [2:0] A, B;
    output [2:0] Y;
    
    assign Y = A + B;
endmodule
        
module fsm (RST, CLK, IN, A, B, O, S, LD);
    input RST, CLK;
    input [2:0] IN;
    output [2:0] A, B, O;
    reg [1:0] state;
    output [1:0] S;
    wire LD_A, LD_B, LD_O;
    wire [2:0] Y;
    output [2:0] LD;
    
    always @(posedge CLK)
        if (RST)
            state <= 2'd0;
        else
            case(state)
                2'd0: state    <= (IN > 3'd0) ? 2'd1 : 2'd0;
                2'd1: state    <= (IN > 3'd0) ? 2'd2 : 2'd1;
                2'd2: state    <= 2'd2;
                default: state <= 2'd0;
            endcase
    
    register_3bit a_reg (RST, CLK, LD_A, IN, A);
    register_3bit b_reg (RST, CLK, LD_B, IN, B);
    register_3bit o_reg (RST, CLK, LD_O, Y, O);
    alu alu (A, B, Y);
    
    assign LD_A = (state == 2'd0) ? 1'b1 : 1'b0;
    assign LD_B = (state == 2'd1) ? 1'b1 : 1'b0;
    assign LD_O = (state == 2'd2) ? 1'b1 : 1'b0;
    
    assign S  = state;
    assign LD = {LD_A, LD_B, LD_O};
endmodule
    
module testbench;
    reg CLK, RST;
    reg [2:0] IN;
    wire [2:0] A, B, O;
    wire[1:0] S;
    wire [2:0] LD;

    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, testbench);
        CLK    <= 0;
        IN     <= 0;
        RST    <= 1; // reset
        #2 RST <= 0;
        #2 IN  <= 2; // hit "2" key
        #2 IN  <= 0; // release "2" key #2IN  <= 4; //hit"4"key
        #2 IN  <= 0; // release "4" key #2 RST  <= 1;
        #2 RST <= 0;
        $finish();
    end
    
    always #1 CLK <= !CLK;
    fsm fsm (RST, CLK, IN, A, B, O, S, LD);
endmodule
