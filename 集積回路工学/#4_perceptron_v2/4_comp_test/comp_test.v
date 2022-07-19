module testbench;
    reg A, B;
    wire [1:0] D;

    initial
    begin
        $dumpfile("comp_test.vcd");
        $dumpvars(0, testbench);
        $monitor("A:%b B:%b D:%b",A, B, D);
        A <= 0;
        B <= 0;
        #4
            $finish;
    end

    always #1
        A <= ~A;
    always #2
        B <= ~B;

   comp inst0(A, B, D);

endmodule