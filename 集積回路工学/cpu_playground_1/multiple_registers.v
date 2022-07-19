`include "register.v";

module multiple_registers (input CK,
                           input LD_A,
                           input LD_B,
                           input LD_out,
                           input [3:0] BUS,
                           output [3:0] A_out,
                           output [3:0] B_out,
                           output [3:0] O_out,
                           );
    register register_A (CK, LD_A, BUS, A_out);
    register register_B (CK, LD_B, BUS, B_out);
    register register_C (CK, LD_out, BUS, O_out);
endmodule
