`include "DataSource.v"

module testbench;
    reg ck;
    wire [7:0] A, B, C;

    initial begin
        $dumpfile("DataSource.vcd");
        $dumpvars(0, testbench);
        ck <= 0;
        #20 $finish;
    end

    always #1
        ck <= ~ck;

    DataSource inst0 (ck, A, B, C);
endmodule