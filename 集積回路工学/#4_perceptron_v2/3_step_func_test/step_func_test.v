module testbench;
    reg [5:0] X;
    wire Y;

    initial
    begin
        $dumpfile("step_func_test.vcd");
        $dumpvars(0, testbench);
        $monitor("X:%b Y:%b", X, Y);
        X <= 6'b100000;
        #64
            $finish;
    end

    always #1
        X <= X + 6'b000001;

    step_func inst0(X, Y);

endmodule