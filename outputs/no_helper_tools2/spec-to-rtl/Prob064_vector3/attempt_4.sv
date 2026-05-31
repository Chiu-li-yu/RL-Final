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

    logic [31:0] concat_bits;

    always @(*) begin
        // Let's manually construct the 32 bits to ensure correctness.
        // {a, b, c, d, e, f, 2'b11}
        // Bit index:
        // [31:27] = a
        // [26:22] = b
        // [21:17] = c
        // [16:12] = d
        // [11:7]  = e
        // [6:2]   = f
        // [1:0]   = 2'b11
        
        concat_bits = {a, b, c, d, e, f, 2'b11};
        
        w = concat_bits[31:24];
        x = concat_bits[23:16];
        y = concat_bits[15:8];
        z = concat_bits[7:0];
    end

endmodule
