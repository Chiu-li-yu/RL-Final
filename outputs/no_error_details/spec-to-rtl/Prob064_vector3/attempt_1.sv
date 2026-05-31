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

    always @(*) begin
        // Concatenate inputs (30 bits) and two 1s (LSB positions)
        // Total 32 bits: {f, e, d, c, b, a, 1, 1}
        combined = {f, e, d, c, b, a, 2'b11};
        
        // Split into 4 outputs of 8 bits each
        {z, y, x, w} = combined;
    end
endmodule
