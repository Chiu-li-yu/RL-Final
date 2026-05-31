module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    always @(*) begin
        // The mux selects 4 bits from a 1024-bit input.
        // sel=0 -> bits [3:0]
        // sel=1 -> bits [7:4]
        // ...
        // sel=255 -> bits [1023:1020]
        // Since sel is 8 bits (up to 255), we can use it to index the 4-bit block.
        // We need to shift the input or use part-select with a variable index.
        // In Verilog, in[(sel*4) +: 4] is the correct syntax for variable part-select.
        out = in[sel * 4 +: 4];
    end

endmodule
