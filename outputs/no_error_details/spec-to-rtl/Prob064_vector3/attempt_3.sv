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
        // Combined is 32 bits. Let's arrange inputs {a, b, c, d, e, f}
        // Total 30 bits, then 2 bits LSB: {a, b, c, d, e, f, 2'b11}
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Split into 4 outputs: {w, x, y, z}
        // Let's assume MSB is w, LSB is z
        {w, x, y, z} = combined;
    end
endmodule
