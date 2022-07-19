module adder_2bit (x, y, z, c);
    input  [1:0] x, y;
    output [1:0] z;
    wire [2:0] z3;
    output c;

    assign z3 = x + y;
    assign z = z3[1:0];
    assign c = z3[2];

endmodule //4-1_adder_2bit

module testbench;
    reg [1:0] x, y;
    wire [1:0] z;
    wire c;

    initial
        begin
            $monitor("%d+%d=%d (carry:%b)", x, y, z, c);
            x <= 0;
            y <= 0;
            #7 $finish;
        end

    always #1 x <= x + 1;
    always #2 y <= y + 1;

    adder_2bit inst0 (x, y, z, c);
endmodule