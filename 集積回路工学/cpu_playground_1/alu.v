module adder_4bit (input [3:0] Y,
                   input [3:0] IM,
                   output [3:0] BUS,
                   output cFlag);
wire [4:0] z;
assign z     = Y+IM;
assign BUS   = z[3:0];
assign cFlag = (z > 4'd15) ? 1'b1 : 1b'0;

endmodule //alu
