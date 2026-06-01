module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);
    logic [31:0] combined;

    always @(*) begin
        // The total bits: a(5), b(5), c(5), d(5), e(5), f(5) = 30 bits.
        // {a, b, c, d, e, f, 2'b11}
        // Let's re-verify the bit concatenation. 
        // a is the most significant.
        combined = {a, b, c, d, e, f, 2'b11};
        
        // This is 32 bits:
        // bit 31-27: a
        // bit 26-22: b
        // bit 21-17: c
        // bit 16-12: d
        // bit 11-7:  e
        // bit 6-2:   f
        // bit 1-0:   11
        
        // Assign to w, x, y, z (8 bits each)
        // w = bits 31-24
        // x = bits 23-16
        // y = bits 15-8
        // z = bits 7-0
        
        {w, x, y, z} = combined;
    end
endmodule
