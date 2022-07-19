`include "DataSource.v"
`include "alu.v"

module testbench;
    reg ck;
    wire [7:0] A, B, C, MUL, ADD;
    
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, testbench);
        ck <= 0;
        #20
            $finish;
    end

    always #1
        ck <= ~ck;

    DataSource inst0 (ck, A, B, C);
    multiplier inst1 (A, B, MUL);
    adder inst2 (MUL, C, ADD);
endmodule
