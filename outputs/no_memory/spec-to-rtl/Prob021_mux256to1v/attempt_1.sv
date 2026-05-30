module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    always @(*) begin
        // The sel input is 8 bits (256 possible values).
        // Each selection corresponds to a 4-bit chunk of the 1024-bit input.
        // The i-th chunk is in[i*4 + 3 : i*4].
        // sel selects the i-th chunk.
        
        // Since sel can be up to 255 (2^8 - 1), and 256 * 4 = 1024,
        // the index calculation is simple: sel * 4.
        out = in[sel * 4 +: 4];
    end

endmodule
