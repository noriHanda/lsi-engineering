module DataSource (ck,
                   A,
                   B,
                   C); input ck;
    reg [2:0] q;
    reg [7:0] a [0:4];
    reg [7:0] b [0:4];
    reg [7:0] c [0:4];
    output [7:0] A, B, C;
    
    initial begin
        q <= 0;
        a[0] = 1;a[1] = 2;a[2] = 3;a[3] = 4;a[4] = 5;
        b[0] = 5;b[1] = 4;b[2] = 3;b[3] = 2;b[4] = 1;
        c[0] = 5;c[1] = 6;c[2] = 7;c[3] = 8;c[4] = 9;
    end
    
    // q = 4 までなるのはなんで？（q = 3 までじゃなく）
    always @(posedge ck)
        if (q < 4)
            q <= q + 1;
    
    assign A = a[q];
    assign B = b[q];
    assign C = c[q];
endmodule
