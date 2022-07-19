module multiplexer (a, b, s, y);
    input a, b, s;
    output y;

    assign y = (s == 1'b0) ? a : b;

endmodule

module testbench;
    reg a, b, s;
    wire y;
    
    initial
        begin
            $monitor("a:%b b:%b s:%b, y=%b", a, b, s, y);
            
            a <= 0;
            b <= 0;
            s <= 0;
            #7 $finish;
        end

    always #1 a <= a + 1;
    always #2 b <= b + 1;
    always #4 s <= s + 1;

    multiplexer inst0 (a, b, s, y);
endmodule