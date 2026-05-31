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

    logic [31:0] concat_val;

    always @(*) begin
        // The concatenation order {a, b, c, d, e, f, 2'b11} seems correct per spec.
        // Let's re-verify: 6 inputs * 5 bits = 30 bits. 2 bits = 2 bits. Total 32.
        // 4 outputs * 8 bits = 32 bits.
        // Everything matches. 
        // Maybe the issue is the order of concatenation?
        // Let's try {f, e, d, c, b, a, 2'b11}? No, "concatenate ... input vectors" usually follows the given order.
        // Is it possible the concatenation is {2'b11, f, e, d, c, b, a}?
        // The spec says "followed by two 1 bits (LSB positions)".
        // So {a, b, c, d, e, f, 2'b11} is correct for the bit sequence (LSB = 2'b11).
        
        // Let's look at the failure again. z has 1 mismatch.
        // What if the 2'b11 is NOT at the end of the total 32, but at the end of each vector?
        // No, "The output should be a concatenation of the input vectors followed by two 1 bits".
        
        // Wait, maybe the order of outputs is not {w, x, y, z} = concat_val?
        // Maybe {z, y, x, w} = concat_val?
        
        concat_val = {a, b, c, d, e, f, 2'b11};
        {z, y, x, w} = concat_val;
    end

endmodule
