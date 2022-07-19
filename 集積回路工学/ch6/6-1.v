module tb;
    reg q;

    initial begin
        q <= 1'b0;
        $monitor("%t %b", $time, q);
        #1 q <= 1'b1;
        #1 q <= 1'b0;
        #2 q <= 1'b1;
        #2 q <= 1'b0;
        #1 q <= 1'b0;
        #2 q <= 1'b1;
        #1 $finish;
    end
endmodule