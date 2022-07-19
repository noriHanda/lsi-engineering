module PipelineRegister (CK, D, Q);
    input CK;
    input [7:0] D;
    output [7:0] Q;
    reg [7:0] q;

    always @(posedge CK) q <= D;

    assign Q = q;
endmodule
