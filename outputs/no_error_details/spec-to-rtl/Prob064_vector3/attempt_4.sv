module TopModule(
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);
    logic [31:0] combined;

    // Concatenate {f, e, d, c, b, a}
    // "concatenation of the input vectors followed by two 1 bits (the two 1 bits should be in the LSB positions)."
    // Let's try {f, e, d, c, b, a} at MSB to LSB.
    // combined = {f, e, d, c, b, a, 2'b11}
    // If output is {w, x, y, z} as 8-bit pieces.
    
    always @(*) begin
        combined = {f, e, d, c, b, a, 2'b11};
        // Split: combined[31:24] = w, combined[23:16] = x, combined[15:8] = y, combined[7:0] = z
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end
endmodule
