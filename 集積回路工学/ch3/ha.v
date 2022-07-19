module Add_half(sum,
                c_out,
                a,
                b);
    input a, b;
    output c_out, sum;
    assign sum   = a ^ b;
    assign c_out = a & b;
endmodule
    
module testbench;
        reg a, b;
        wire sum, c_out;

        initial
        begin
            $dumpfile("ha.vcd");
            $dumpvars(0, testbench);
            $monitor("%t: a:%b b:%b sum:%b c:%b", $time, a, b, sum, c_out);
            a <= 0;
            b <= 0;
            #3
                $finish;
        end
        always #1
            a <= ~a;
        always #2
            b <= ~b;

        Add_half inst0 (sum, c_out, a, b);
endmodule
