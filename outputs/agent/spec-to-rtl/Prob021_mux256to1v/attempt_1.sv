module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    always @(*) begin
        // The input is a 1024-bit vector.
        // It consists of 256 segments of 4-bit values.
        // sel indicates which 4-bit segment to select.
        // Since sel is 8 bits (0-255), we can index directly.
        // We use the selection to slice the 1024-bit vector.
        // Each segment is 4 bits wide.
        // Segment i corresponds to bits [4*i + 3 : 4*i].
        out = in[sel * 4 + 3 -: 4];
    end

endmodule
