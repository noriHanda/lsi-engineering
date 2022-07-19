module memory_2bit_8word (D, WR, AD, Q);
    input WR;
    input [1:0] D;
    input [2:0] AD;
    output [1:0] Q;

    reg [1:0] q[0:7];

    always @(posedge WR) q[AD] <= D;

    assign Q = q[AD];
endmodule

module testbench; 
    reg [2:0] AD;
    reg WR;
    wire [1:0] Q;
    
    initial begin
        $monitor("ADR:%b WR:%b Q:%b", AD, WR, Q);
        AD <= 3'b0;
        WR <= 1'b0;
        #31 $finish;
    end

    always #2 AD <= AD + 3'b1;
    always #1 WR <= ~WR;

    memory_2bit_8word inst0 (2'b11, WR, AD, Q);
endmodule
