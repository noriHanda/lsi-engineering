// Instruction Memory
module im(dout,
          addr);
    output [12:0] dout;
    input [7:0] addr;
    
    reg [12:0] mem [0:255];
    
    initial begin
        mem[8'd0]  <= {5'b00011, 8'd0};
        mem[8'd1]  <= {5'b01000, 8'd0};
        mem[8'd2]  <= {5'b01001, 8'd0};
        mem[8'd3]  <= {5'b01000, 8'd1};
        mem[8'd4]  <= {5'b01001, 8'd0};
        mem[8'd5]  <= {5'b00011, 8'd1};
        mem[8'd6]  <= {5'b00100, 8'd0};
        mem[8'd7]  <= {5'b01100, 8'd0};
        mem[8'd8]  <= {5'b01001, 8'd0};
        mem[8'd9]  <= {5'b01000, 8'd0};
        mem[8'd10] <= {5'b01011, 8'd0};
        mem[8'd11] <= {5'b00100, 8'd0};
        mem[8'd12] <= {5'b01100, 8'd0};
        mem[8'd13] <= {5'b01001, 8'd0};
        mem[8'd14] <= {5'b01000, 8'd1};
        mem[8'd15] <= {5'b01011, 8'd0};
        mem[8'd16] <= {5'b00100, 8'd0};
        mem[8'd17] <= {5'b01100, 8'd0};
        mem[8'd18] <= {5'b01111, 8'd8};
    end
    
    assign dout = mem[addr];
endmodule
