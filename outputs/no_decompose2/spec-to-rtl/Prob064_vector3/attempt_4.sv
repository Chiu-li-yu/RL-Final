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

    // The specification says "concatenate the input vectors together 
    // followed by two 1 bits (the two 1 bits should be in the LSB positions)."
    // Let's assume the input concatenation order is a, b, c, d, e, f.
    // {a, b, c, d, e, f, 2'b11} is 30 + 2 = 32 bits.

    always @(*) begin
        concat_data = {a, b, c, d, e, f, 2'b11};
        w = concat_data[31:24];
        x = concat_data[23:16];
        y = concat_data[15:8];
        z = concat_data[7:0];
    end

endmodule
