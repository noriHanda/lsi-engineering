module testbench;
    reg CLK;
    reg X1, X2;
    wire Z;
    wire [1:0] DELTA;
    wire [3:0] W1, W2, W3;
    wire [1:0] STATE;

    wire s;

    assign s = X1 & X2; // and
    // assign s = !(X1 & X2); // or

    initial
    begin
        $dumpfile("perceptron.vcd");
        $dumpvars(0, testbench);
        // $monitor("%t | CLK:%b | X1:%b X2:%b | W1:%b W2:%b W3:%b | Z:%b | S:%b | DELTA:%b", 
        //           $time, CLK, X1, X2, W1, W2, W3, Z, S, DELTA);

        CLK <= 0;
        X1 <= 0;
        X2 <= 0;
        // S <= 0;

        #120
            $finish;
    end

    always #1
        CLK <= ~CLK;
    always #8 begin
        X1 <= ~X1;
        // S <= s;
    end
    always #16
       X2 <= ~X2;

    perceptron perceptron(CLK, X1, X2, W1, W2, W3, Z, s, DELTA, STATE);


endmodule