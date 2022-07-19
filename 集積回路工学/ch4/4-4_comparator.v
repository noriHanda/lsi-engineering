module comparator_2bit (a, b, a_gt_b, a_eq_b, a_lt_b);
    input [1:0] a, b;
    output a_gt_b, a_eq_b, a_lt_b;

    assign a_gt_b = (a > b) ? 1'b1 : 1'b0;
    assign a_eq_b = (a == b) ? 1'b1 : 1'b0;
    assign a_lt_b = (a < b) ? 1'b1 :1'b0;

endmodule

module testbench;
    reg [1:0] a, b;
    wire a_gt_b, a_eq_b, a_lt_b;

    initial
            begin
                $monitor("a:%d b:%d, a>b:%b, a=b:%b, a<b:%b", a, b, a_gt_b, a_eq_b, a_lt_b);
                a <= 0;
                b <= 0;
                #15 $finish;
            end
        
    always #1 a <= a + 1;
    always #4 b <= b + 1;
    
    comparator_2bit inst0 (a, b, a_gt_b, a_eq_b, a_lt_b);
endmodule