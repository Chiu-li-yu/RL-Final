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
    // The requirement says: 
    // "concatenation of the input vectors followed by two 1 bits (the two 1 bits should be in the LSB positions)"
    // Input is 30 bits. Output is 32 bits.
    // Concatenation: {a, b, c, d, e, f} (30 bits)
    // Combined 32 bits: {a, b, c, d, e, f, 2'b11}
    //
    // Maybe the order of assignment is different?
    // "The output should be a concatenation of the input vectors followed by two 1 bits"
    // Let's try explicitly assigning:
    
    always @(*) begin
        w = {a, b[4:2]};
        x = {b[1:0], c, d[4]};
        y = {d[3:0], e[4:1]};
        z = {e[0], f, 2'b11};
    end
endmodule
