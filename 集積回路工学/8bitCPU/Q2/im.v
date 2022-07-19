// Instruction Memory
module im(dout,
          addr);
    output [12:0] dout;
    input [7:0] addr;
    
    reg [12:0] mem [0:255];
    
    initial begin
        mem[8'd0] <= {5'b00111, 8'd0 };	// MOV B, 0;
        mem[8'd1] <= {5'b00110, 8'b11001110};	// IN B, in - 50;
        mem[8'd2] <= {5'b01100, 8'd0 };	// OUT B + 0;
        mem[8'd3] <= {5'b01111, 8'd1 };	// JMP 1;
    end
    
    assign dout = mem[addr];
endmodule
