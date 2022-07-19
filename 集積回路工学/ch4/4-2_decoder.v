module decoder (in, out);
    input  [1:0] in;
    output [3:0] out;

    assign out[0] = (in == 2'd0) ? 1'b1 : 1'b0;
    assign out[1] = (in == 2'd1) ? 1'b1 : 1'b0;
    assign out[2] = (in == 2'd2) ? 1'b1 : 1'b0;
    assign out[3] = (in == 2'd3) ? 1'b1 : 1'b0;
endmodule

module testbench;
    reg [1:0] in;
    wire [3:0] out;

    initial
            begin
                $monitor("in=%d, out=%b", in, out);
                in <= 0;
                #3 $finish;
            end

    always #1 in <= in + 1;

    decoder inst0 (in, out);
endmodule