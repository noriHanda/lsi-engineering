module rom_10bit_64word(AD,
                        Q);
    input [5:0] AD;
    output [9:0] Q;
    
    reg [9:0] q [0:63];
    
    initial begin
        // Hazardous code
        q[6'd0] <= {4'b0011, 6'd0};
        q[6'd1] <= {4'b0101, 6'd0};
        q[6'd2] <= {4'b1001, 6'd0};
        q[6'd3] <= {4'b1011, 6'd3};
        
        // fixed code
        // q[6'd0] <= {4'b0011, 6'd0};
        // q[6'd1] <= {4'b0000, 6'd0};
        // q[6'd2] <= {4'b0101, 6'd0};
        // q[6'd3] <= {4'b0000, 6'd0};
        // q[6'd4] <= {4'b1001, 6'd0};
        // q[6'd5] <= {4'b1011, 6'd5};
        // q[6'd6] <= {4'b0000, 6'd0};
        // q[6'd7] <= {4'b0000, 6'd0};
        // q[6'd8] <= {4'b0000, 6'd0};
    end
    
    assign Q = q[AD];
endmodule
