module s1 (out);
    output out;
    reg q;
    assign out = q;
    initial q <= 1'b1;
    always #1 q <= ~q;
endmodule

module s2 (out);
    output out;
    reg q;
    assign out = q;
    initial q <= 1'b1;
    always #2 q <= ~q;
endmodule

module testbench;
    wire s1, s2;
    initial begin
       $monitor("%t s1:%b s2:%b", $time, s1, s2);
       #15 $finish;
    end

    s1 inst0 (s1);
    s2 inst1 (s2);
endmodule