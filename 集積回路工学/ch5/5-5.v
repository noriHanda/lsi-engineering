module s3(out);
    output out;
    reg [1:0] q;
    assign out = (q == 2'd0) ?
        1'b1 : 1'b0;
    initial q <= 2'd0;
    always #1 q <= q + 2'd1;
endmodule

module testbench;
    reg c;
    wire s3;
    initial begin
        $monitor("%t c:%b s3:%b", $time, c, s3);
        c <= 1'b0;
        #15 $finish;
    end

    always #1 c <= ~c;

    s3 inst0 (s3);
endmodule
