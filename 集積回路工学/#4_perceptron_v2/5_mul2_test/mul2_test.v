module testbench;
    reg A;
    reg [1:0] B;
    wire [1:0] P;

    initial
    begin
        $dumpfile("mul2_test.vcd");
        $dumpvars(0, testbench);
        $monitor("A:%b B:%d P:%d",A, B, P);
        A <= 0;
        B <= 0;
        #8
            $finish;
    end

    always #1
        A <= ~A;
    always #2
        B <= B + 1;

    mul2 inst0(A, B, P);

endmodule