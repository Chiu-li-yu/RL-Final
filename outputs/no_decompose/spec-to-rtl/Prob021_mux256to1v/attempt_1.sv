module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    always @(*) begin
        // sel is 8 bits (0-255), we want to select 4 bits.
        // The input in is 1024 bits (256 * 4 bits).
        // For a given sel, the starting bit index is sel * 4.
        // The range is [sel*4 + 3 : sel*4].
        out = in[sel * 4 +: 4];
    end

endmodule
