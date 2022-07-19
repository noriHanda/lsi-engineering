module D_logic(D,
               CK,
               S,
               R);
    input D, CK;
    output S, R;
    wire w;
    assign S = D & CK;
    assign R = w & CK;
    assign w = ~S;
endmodule
    
module testbench;
    reg D, CK;
    wire S, R;
    
    initial
    begin
        $dumpfile("dl.vcd");
        $dumpvars(0, testbench);
        $monitor("%t: D:%b CK:%b S:%b R:%b", $time, D, CK, S, R);
        D  <= 0;
        CK <= 0;
        #4
            $finish;
    end
    
    always #1
        D <= ~D;
    always #2
        CK <= ~CK;

    D_logic inst0 (D, CK, S, R);
endmodule
