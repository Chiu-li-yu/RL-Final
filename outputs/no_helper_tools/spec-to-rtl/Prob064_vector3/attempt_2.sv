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
        // The problem asks for concatenation: a, b, c, d, e, f, 2'b11
        // The total bits: 5*6 + 2 = 32 bits.
        // The outputs are w, x, y, z (8 bits each, total 32).
        // Standard Verilog concatenation {w, x, y, z} = combined assigns:
        // w[7:0] = combined[31:24]
        // x[7:0] = combined[23:16]
        // y[7:0] = combined[15:8]
        // z[7:0] = combined[7:0]
        // Which matches the order of {a, b, c, d, e, f, 1, 1}
        combined = {a, b, c, d, e, f, 2'b11};
        {w, x, y, z} = combined;
    end

endmodule
