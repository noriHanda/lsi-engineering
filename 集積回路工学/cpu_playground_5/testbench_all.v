`include "alu.v"
`include "DataSource.v"
`include "PipelineRegister.v"

module testbench;
    reg ck; 
    wire [7:0] A, B, C, MUL, Q1, Q2, Y;

    initial begin 
        $dumpfile("PipelineTest.vcd"); 
        $dumpvars(0, testbench);
        ck <= 0;
        #20
            $finish;
    end
    
    always #1
        ck <= ~ck;
    
    DataSource inst0 (ck, A, B, C); 
    multiplier inst1 (A, B, MUL); 
    PipelineRegister inst2 (ck, MUL, Q1); 
    PipelineRegister inst3 (ck, C, Q2); 
    adder inst4 (Q1, Q2,Y);
endmodule