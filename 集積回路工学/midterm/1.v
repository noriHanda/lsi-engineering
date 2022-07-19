module comp (input [2:0] A,
             input [2:0] B,
             output [1:0] O);
assign O = (A > B) ? 2'd2 : (A == B) ? 2'd1 : 2'd0;
endmodule

module testbench;
    reg [2:0] a, b;
    wire [1:0] out;
    
    initial begin
        $monitor("A:%d B:%d O:%d", a, b, out);
        a <= 3'd0;
        b <= 3'd2;
        #3 $finish;
    end
    
    always begin
        #1 a <= a + 3'd1;
        #1 b <= b - 3'd1;
    end
    
    comp inst0 (a, b, out);
endmodule
