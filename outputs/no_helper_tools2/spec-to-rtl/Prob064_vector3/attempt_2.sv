module TopModule(
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
        // The spec says concatenation of input vectors followed by two 1 bits
        // Input sequence: a, b, c, d, e, f (5*6 = 30 bits)
        // 30 bits + 2 bits = 32 bits total.
        // {w, x, y, z} = {a, b, c, d, e, f, 2'b11}
        // In Verilog, the concatenation {w, x, y, z} maps to 32 bits where w is MSB.
        // So {w, x, y, z} = {a, b, c, d, e, f, 2'b11} is correct.
        // Let's re-examine the concatenation.
        concat_data = {a, b, c, d, e, f, 2'b11};
        
        w = concat_data[31:24];
        x = concat_data[23:16];
        y = concat_data[15:8];
        z = concat_data[7:0];
    end

endmodule
