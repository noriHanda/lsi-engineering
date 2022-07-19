module majority_logic (a, b, c, pass);
    input a, b, c;
    output pass;

    assign pass = (a + b + c > 2'd1) ? 1'b1 : 1'b0;

endmodule

module testbench;
    reg a, b, c;
    wire pass;

    initial
        begin
                $monitor("a:%b b:%b c:%b, pass=%b", a, b, c, pass);
                a <= 0;
                b <= 0;
                c <= 0;
                #15 $finish;
        end

    always #1 a <= a + 1;
    always #2 b <= b + 1;
    always #4 c <= c + 1;

    majority_logic inst0 (a, b, c, pass);
endmodule