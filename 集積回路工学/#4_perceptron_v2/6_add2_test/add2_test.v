module testbench;
    reg [3:0] A;
    reg [1:0] B;
    wire [3:0] S;

    initial
    begin
        $dumpfile("add2_test.vcd");
        $dumpvars(0, testbench);
        $monitor("A:%b B:%b S:%b",A, B, S);
        A <= 4'b1001;
        B <= 2'b01;

        #14
            B <= 2'b00;
        #14
            B <= 2'b11;
        #14
            $finish;

    end


    always #1
        A <= (A == 4'b0110) ? 4'b1001 : A + 4'b0001;

    add2 inst0(A, B, S);

endmodule