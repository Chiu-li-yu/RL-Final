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
        // The concatenation order should match the output mapping order
        // The problem says: concatenate input vectors (a, b, c, d, e, f)
        // followed by 2 bits.
        // Total bits: 30 + 2 = 32.
        // Output concatenation: {w, x, y, z}
        // w should be the most significant, z should be the least.
        combined = {a, b, c, d, e, f, 2'b11};
        {w, x, y, z} = combined;
    end

endmodule
