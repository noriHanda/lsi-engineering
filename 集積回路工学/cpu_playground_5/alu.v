module adder (A, B, Y);
    input [7:0] A, B;
    output [7:0] Y;
    assign Y = A + B;
endmodule

module multiplier (A, B, Y);
    input [7:0] A, B;
    output [7:0] Y;
    assign Y = A * B;
endmodule