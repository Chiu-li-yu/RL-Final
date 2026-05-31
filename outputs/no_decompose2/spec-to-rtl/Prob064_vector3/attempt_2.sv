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
        // The total bits: 5 * 6 = 30.
        // We need to concatenate the inputs, followed by two 1 bits.
        // concat_data = {a, b, c, d, e, f, 1'b1, 1'b1};
        // The outputs are w, x, y, z (8 bits each, 32 bits total).
        // Assignment: {w, x, y, z} = concat_data;
        // This makes w the MSB part.
        
        concat_data = {a, b, c, d, e, f, 2'b11};
        w = concat_data[31:24];
        x = concat_data[23:16];
        y = concat_data[15:8];
        z = concat_data[7:0];
    end

endmodule
