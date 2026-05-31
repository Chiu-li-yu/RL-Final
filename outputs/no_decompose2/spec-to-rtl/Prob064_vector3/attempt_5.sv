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

    // Concatenate a, b, c, d, e, f, 1, 1
    // Total bits = 5 + 5 + 5 + 5 + 5 + 5 + 1 + 1 = 32
    // {a, b, c, d, e, f, 2'b11}
    
    // Maybe the problem expects the bit ordering to be different?
    // Let's try 32'b11 instead of 2'b11? No, that would be 32 bits + 30 bits.
    // What if the order is not a,b,c,d,e,f?
    
    // Let's re-read: "The output should be a concatenation of the input vectors 
    // followed by two 1 bits (the two 1 bits should be in the LSB positions)."
    
    // Maybe the test expects the 1s to be 1'b1, 1'b1?
    
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule
