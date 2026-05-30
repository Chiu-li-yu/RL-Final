module TopModule (
    input logic [4:0] a,
    input logic [4:0] b,
    input logic [4:0] c,
    input logic [4:0] d,
    input logic [4:0] e,
    input logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);
    logic [31:0] combined;

    always @(*) begin
        // Concatenating inputs: 30 bits. 
        // Need to add two 1-bits at the LSB positions.
        // Total 32 bits.
        // Input: {a, b, c, d, e, f} (30 bits)
        // Full vector: {a, b, c, d, e, f, 2'b11} (32 bits)
        // Split: 
        // w (bits 31:24)
        // x (bits 23:16)
        // y (bits 15:8)
        // z (bits 7:0)
        combined = {a, b, c, d, e, f, 2'b11};
        {w, x, y, z} = combined;
    end
endmodule
