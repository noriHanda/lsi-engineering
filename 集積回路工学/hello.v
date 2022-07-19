module multiplexer(a, b, s, y);
    input a, b, s;
    output y;

    assign y=(s==1'b0)?a:b;
endmodule