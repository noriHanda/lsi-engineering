module and (o,
            a,
            b);
    output o;
    input a, b;
    assign o = a&b;
endmodule
    
    module and3(o,a,b,c);
        output o;
        input a, b, c;
        wire d;
        
        and and0 (d,a,b);
        and and1 (o,d,c);
    endmodule
