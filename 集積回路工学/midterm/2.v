module alu (input com,
            input [1:0] A,
            input [1:0] B,
            output [2:0] O,
            output C);
    wire [3:0] O4;
    
    assign O4 = (com == 0) ? A + B : 2'b10 * (A + B);
    assign O  = O4[2:0];
    assign C  = O4[3];
endmodule
    
module testbench;
    reg [1:0] a, b;
    reg com;
    wire [2:0] out;
    wire c;
    
    initial begin
        $monitor("com:%b A:%b B:%b O:%b C:%b", com, a, b, out, c);
        com <= 1'b0;
        a   <= 2'b0;
        b   <= 2'b0;
        #30 $finish;
    end
    
    always #5 com <= ~com;
    always begin
        #1 a <= a + 1'b1;
        #1 b <= b + 1'b1;
    end
    
    alu inst0 (com, a, b, out, c);
endmodule
