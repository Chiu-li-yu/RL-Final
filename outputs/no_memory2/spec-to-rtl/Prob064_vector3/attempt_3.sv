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
        // Concatenate inputs (30 bits) and two 1 bits (LSB positions)
        // Total 32 bits
        concat_data = {a, b, c, d, e, f, 2'b11};
        
        // Split into four 8-bit output vectors
        // w (MSB), x, y, z (LSB)
        {w, x, y, z} = concat_data;
    end

endmodule
