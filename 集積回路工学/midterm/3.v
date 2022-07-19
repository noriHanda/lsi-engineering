module DFF (input CK,
            input D,
            output Q,
            input S,
            input R);
    
    initial Q <= 1'b0;
    
    always @(posedge CK) Q <= (S == 1'b1 && R == 1'b0) ? D : (S == 1'b0 && R == 1'b1) ? 1'd0;
endmodule
    
module testbench;
    reg ck, d, s, r;
    wire q;
    
    initial begin
        $monitor("CK:%b D:%b Q:%b S:%b R:%b", ck, d, q, s, r);
        ck <= 2'd0;
        d  <= 1'd1;
        s  <= 1'd1;
        r  <= 1'd0;
        #10 $finish;
    end

    always begin
        #2 ck <= ~ck;
        #3 s <= ~s;
        #4 r <= ~r;
        #1 d <= ~d;
    end

    DFF inst0 (ck, d, q, s, r);
endmodule
        
