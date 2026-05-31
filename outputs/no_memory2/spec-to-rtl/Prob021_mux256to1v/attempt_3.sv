module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    // 256-to-1 multiplexer for 4-bit segments
    // in[0:3] -> index 0, in[4:7] -> index 1, ...
    // The selection is based on 8-bit 'sel'.
    // Since we only have 256 possibilities (8 bits), 
    // and input is 1024 bits (256 * 4 bits),
    // we use 'sel' to pick the 4-bit segment.

    always_comb begin
        // Use the index provided by sel to pick the 4-bit chunk.
        // Each chunk is 4 bits wide. The starting bit index is sel * 4.
        out = in[sel*4 +: 4];
    end

endmodule
