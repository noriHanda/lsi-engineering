module nand2 (a, b, y);
    input a, b;
    output y;
    assign y = ~(a & b);
endmodule

module testbench_nand2;
    reg in1, in2;
    wire out;

    initial begin
        in1 <= 1'b0;
        in2 <= 1'b0;
        $monitor("%t %b %b %b", $time, in1, in2, out);
        #3 $finish;
    end

    always
        #1 in1 <= ~in1;
    always
        #2 in2 <= ~in2;
        
    nand2 inst (in1, in2, out);
endmodule
