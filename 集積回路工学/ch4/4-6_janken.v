module janken (a, b, a_win, b_win, even);
    input a, b;
    output a_win, b_win, even;

    assign a_win = (a == 1'b0 && b == 1'b1) ? 1'b1 : 1'b0;
    assign b_win = (a == 1'b1 && b == 1'b0) ? 1'b1 : 1'b0;
    assign even = (a == b) ? 1'b1 : 1'b0;
endmodule

module testbench;
    reg a, b;
    wire a_win, b_win, even;
    
    initial
        begin
            $monitor("a:%b b:%b, a_win:%b b_win:%b even:%b", a, b, a_win, b_win, even);
            a <= 0;
            b <= 0;
            #3 $finish;
        end
        
    always #1 a <= a + 1;
    always #2 b <= b + 1;
    
    janken inst0 (a, b, a_win, b_win, even);
endmodule
