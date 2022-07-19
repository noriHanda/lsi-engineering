module e_counter (input CK,
                  input E,
                  output O);
    initial O <= 1'd0;
    always @(posedge CK) begin
        O <= (E == 1'b1) ? O + 1'd1;
    end
    
endmodule
