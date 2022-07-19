module testbench;
    reg ck, we, cs;
    reg [`ADDRESS_BIT-1:0] addr;
    reg [`DATA_BIT-1:0] wdata;

    wire [`DATA_BIT-1:0] rdata;

    initial
    begin
        $dumpfile("sync_sram.vcd");
        $dumpvars(0, testbench);
        ck <= 0; we <= 1; cs <= 1;
        addr <= 15;
        wdata <= 0;
        #32
        we <= 0;
        #32
        cs <= 0;
        #4
        $finish;
    end

    sync_sram inst0(ck, addr, cs, we, rdata, wdata);

    always #1 ck <= ~ck;

    always @(negedge ck)
    begin
        addr <= addr + 1;
        wdata <= wdata - 1;
    end
endmodule
