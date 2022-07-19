module tb1;
    reg q;

    initial begin
        q <= 1'b0;
        $monitor("%t %b", $time, q);
        #10 $finish;
    end
    
    always
        #1 q <= ~q;
endmodule

module tb2;
    reg q;

    initial begin
        q <= 1'b0;
        $monitor("%t %b", $time, q);
        #10 $finish;
    end

    always
        #2 q <= ~q;
endmodule