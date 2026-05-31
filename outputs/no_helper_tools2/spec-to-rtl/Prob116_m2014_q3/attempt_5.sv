module TopModule (
    input logic [3:0] x,
    output logic f
);
    // Maybe the mapping is different. 
    // "x[3]x[4] on the left and x[1]x[2] on top"
    // Usually, this implies the indices are bits x[3], x[2] and x[1], x[0].
    // Let's try every bit permutation for the mapping? No.
    // Let's look at the table again:
    //      x1 x2
    // x3 x4  00 01 11 10
    // 00 | d | 0 | d | d |
    // 01 | 0 | d | 1 | 0 |
    // 11 | 1 | 1 | d | d |
    // 10 | 1 | 1 | 0 | d |
    
    // Maybe the bits are x[3], x[2], x[1], x[0]
    // The table indicates:
    // Row bits: x[3] (MSB) and x[2] (LSB)
    // Col bits: x[1] (MSB) and x[0] (LSB)
    // Table indices are 00, 01, 11, 10
    
    // Let's re-calculate logic expression.
    // Map = 
    // {0,0,0,0}: d, {0,0,0,1}: 0, {0,0,1,1}: d, {0,0,1,0}: d
    // {0,1,0,0}: 0, {0,1,0,1}: d, {0,1,1,1}: 1, {0,1,1,0}: 0
    // {1,1,0,0}: 1, {1,1,0,1}: 1, {1,1,1,1}: d, {1,1,1,0}: d
    // {1,0,0,0}: 1, {1,0,0,1}: 1, {1,0,1,1}: 0, {1,0,1,0}: d
    
    // Simplification by grouping:
    // F = (x[3] & ~x[1]) | (~x[3] & x[2] & x[1] & x[0]) | ...
    
    always @(*) begin
        // Let's try: f = (x[3] & ~x[2]) | (x[3] & x[2] & ~x[0]) | (~x[3] & x[2] & x[1] & x[0])
        f = (x[3] & ~x[2]) | (x[3] & x[2] & ~x[0]) | (~x[3] & x[2] & x[1] & x[0]);
    end
endmodule
