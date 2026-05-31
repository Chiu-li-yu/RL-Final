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
        // The concatenation order in the problem:
        // "concatenate the input vectors together ... followed by two 1 bits (LSB positions)"
        // Assuming f is MSB (f, e, d, c, b, a)
        combined = {f, e, d, c, b, a, 2'b11};
        
        // Output concatenation: {w, x, y, z} order from MSB to LSB
        // w is MSB, z is LSB
        {w, x, y, z} = combined;
    end
endmodule
