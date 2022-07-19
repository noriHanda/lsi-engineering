`include "PipelineRegister.v"
module testbench;
    reg ck;
    reg [7:0] in;
    wire [7:0] Q;
    
    initial begin
        $dumpfile("PipelineRegister.vcd");
        $dumpvars(0, testbench);
        ck <= 0;
        in <= 0;
        #10
            $finish;
    end
    
    always #1
        ck <= ~ck;
    
    always @(posedge ck)
        in <= in + 1;
        
    PipelineRegister inst0 (ck, in, Q);
endmodule
