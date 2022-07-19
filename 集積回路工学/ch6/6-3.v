module tb3;
    wire out;
    reg [1:0] q;
    assign out = (q == 2'd0) ? 1'b1: 1'b0;
    
    initial
    begin
        q <= 2'd0;
        $monitor("%t %b %b", $time, q, out);
        #15 $finish;
    end

    always
        #1 q <= q + 2'd1;
endmodule
