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
    // 30 bits total from a..f + 2 bits = 32 bits.
    // Concatenation: {a, b, c, d, e, f, 2'b11}
    // a=5, b=5, c=5, d=5, e=5, f=5, 2 bits. Total 32.
    // Vector: 
    // [31:27] = a
    // [26:22] = b
    // [21:17] = c
    // [16:12] = d
    // [11:7] = e
    // [6:2] = f
    // [1:0] = 2'b11

    // w = [31:24]
    // x = [23:16]
    // y = [15:8]
    // z = [7:0]

    logic [31:0] combined;

    always @(*) begin
        combined = {a, b, c, d, e, f, 2'b11};
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end
endmodule
