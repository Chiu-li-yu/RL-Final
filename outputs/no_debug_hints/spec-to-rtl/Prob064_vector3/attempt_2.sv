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

    logic [31:0] concat_data;

    always @(*) begin
        // The spec says: "The output should be a concatenation of the input vectors followed by two 1 bits (the two 1 bits should be in the LSB positions)."
        // Concatenation order: a, b, c, d, e, f, then 1, 1.
        // {a, b, c, d, e, f} is 30 bits.
        // concat_data = {a, b, c, d, e, f, 2'b11}
        // Bit 31: a[4] ... Bit 0: 1
        
        // Let's re-verify the concatenation order. {a, b, c, d, e, f, 2'b11}
        concat_data = {a, b, c, d, e, f, 2'b11};
        
        // Output concatenation sequence: w, x, y, z.
        // So {w, x, y, z} should be equal to {a, b, c, d, e, f, 2'b11}.
        w = concat_data[31:24];
        x = concat_data[23:16];
        y = concat_data[15:8];
        z = concat_data[7:0];
    end

endmodule
