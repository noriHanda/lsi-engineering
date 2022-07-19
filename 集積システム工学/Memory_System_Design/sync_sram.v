`define DATA_BIT 8     // 8 bit
`define ADDRESS_BIT 4  // 16 word

module sync_sram(CK,
                 ADDR,
                 CS,
                 WE,
                 RDATA,
                 WDATA);
    // IO ports
    input CK, CS, WE;
    input [`ADDRESS_BIT-1:0] ADDR;
    input [`DATA_BIT-1:0] WDATA;
    output [`DATA_BIT-1:0] RDATA;

    reg [`DATA_BIT-1:0] mem [0:2**`ADDRESS_BIT-1];  // Memory array

    // Timing buffers
    reg [`ADDRESS_BIT-1:0] adr;
    reg we, cs;
    reg [`DATA_BIT-1:0] rdata, wdata;

    wire [`DATA_BIT-1:0] himp;  // High impedance wire


    // Sychronizing all the inputs with the clock
    always @(posedge CK)
    begin
        adr <= ADDR; cs <= CS;
        we  <= WE; wdata  <= WDATA;
    end

    always @(negedge CK)
    begin
        if (we && cs)
            mem[adr] <= wdata;
        rdata <= (cs) ? mem[adr] : himp;     // Read
    end

    assign RDATA = rdata;
    assign himp = 8'bzzzzzzzz; // High Impedance
endmodule
