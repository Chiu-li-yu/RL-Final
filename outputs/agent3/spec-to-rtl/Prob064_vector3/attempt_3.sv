module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);
    logic [31:0] combined;

    always @(*) begin
        // The output should be a concatenation of the input vectors followed by two 1 bits
        // Input order: a, b, c, d, e, f (5 bits each = 30 bits)
        // 32 bits total = {a, b, c, d, e, f, 2'b11}
        // Wait, the order of assignment to 8-bit outputs {w, x, y, z} = combined;
        // {w, x, y, z} = {a, b, c, d, e, f, 2'b11}
        // This implies w is the MSB side.
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Split into 4 outputs of 8 bits each
        {w, x, y, z} = combined;
    end
endmodule
