module TopModule (
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [31:0] combined;

    always @(*) begin
        // The spec says:
        // "concatenate the input vectors together ... followed by two 1 bits (LSB positions)"
        // Concatenating 6 vectors of 5 bits = 30 bits.
        // Adding 2 bits = 32 bits.
        // Order: {a, b, c, d, e, f, 2'b11}
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Output concatenation: {w, x, y, z} = combined
        // {w, x, y, z} = combined implies:
        // w = combined[31:24]
        // x = combined[23:16]
        // y = combined[15:8]
        // z = combined[7:0]
        
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end

endmodule
