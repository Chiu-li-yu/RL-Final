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
        // The concatenation order should be: {a, b, c, d, e, f, 1, 1}
        // Let's re-verify the split order.
        // {w, x, y, z} = combined; 
        // This splits combined[31:24] to w, [23:16] to x, [15:8] to y, [7:0] to z.
        combined = {a, b, c, d, e, f, 2'b11};
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end
endmodule
