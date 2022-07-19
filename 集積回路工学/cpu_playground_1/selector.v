module selector (input [1:0] S; input [3:0] C0,
                 input [3:0] C1,
                 input [3:0] C2,
                 input [3:0] C3,
                 output [3:0] Y);

assign Y = (S == 2'd0) ? C0 :
            (S == 2'd1) ? C1 :
            (S == 2'd2) ? C2 :
            (S == 2'd3) ? C3;

endmodule //selector
