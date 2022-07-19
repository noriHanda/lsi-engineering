module testbench;
    reg [3:0] A, B, C;
    wire [5:0] S;
    initial
    begin
        $dumpfile("add1_test.vcd");
        $dumpvars(0, testbench);
        $monitor("A:%b B:%b C:%b S:%b", A, B, C, S);
        A <= 4'b1100;
        B <= 4'b1010;
        C <= 4'b1000;
        #9
        B <= 4'b0011;
        #9
        B <= 4'b1101;
        C <= 4'b0111;
        #9
        B <= 4'b0110;
        #9
            $finish;
    end

    always #1
        A <= (A == 4'b0100) ? 4'b1100 : A + 4'b0001;

    add1 inst0(A, B, C, S);

endmodule