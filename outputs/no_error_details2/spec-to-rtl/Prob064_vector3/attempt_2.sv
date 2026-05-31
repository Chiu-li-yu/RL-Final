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
        // The concatenation order should be: {a, b, c, d, e, f, 2'b11}
        // Then split into 4 outputs of 8 bits each
        // Since the specification says:
        // "output vectors w, x, y, z"
        // And "a 32-bit concatenation... split into four 8-bit output vectors"
        // Standard verilog concatenation packing:
        // concat_data = {a, b, c, d, e, f, 2'b11}
        // w is MSB byte, z is LSB byte
        concat_data = {a, b, c, d, e, f, 2'b11};
        
        w = concat_data[31:24];
        x = concat_data[23:16];
        y = concat_data[15:8];
        z = concat_data[7:0];
    end

endmodule
