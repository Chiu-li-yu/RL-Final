module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    always @(*) begin
        // The sel is 8 bits (0-255), which correctly maps to 256 items.
        // Each item is 4 bits wide.
        // The selection index is sel * 4.
        // The bits are in[sel*4 +: 4].
        out = in[sel*4 +: 4];
    end

endmodule
