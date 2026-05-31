module TopModule (
    input [3:0] x,
    output f
);
    // Inputs: x[3], x[4], x[1], x[2] (based on K-map row/col)
    // Map Table:
    // x3 x4 | x1 x2
    //       | 00 | 01 | 11 | 10
    // 00    |  d | 0  | d  | d
    // 01    |  0 | d  | 1  | 0
    // 11    |  1 | 1  | d  | d
    // 10    |  1 | 1  | 0  | d

    // Inputs: x = {x[3], x[4], x[1], x[2]} (Assuming index matches the order x[3]x[4]x[1]x[2])
    // Wait, the input is x[3:0]. Let's map it:
    // Let R = {x[3], x[4]} (Row), C = {x[1], x[2]} (Col)
    
    // K-map:
    // R\C | 00 | 01 | 11 | 10
    // 00  |  d | 0  | d  | d
    // 01  |  0 | d  | 1  | 0
    // 11  |  1 | 1  | d  | d
    // 10  |  1 | 1  | 0  | d
    
    // Logic:
    // f = 1 at:
    // (R=01, C=11) -> x[3]=0, x[4]=1, x[1]=1, x[2]=1
    // (R=11, C=00) -> x[3]=1, x[4]=1, x[1]=0, x[2]=0
    // (R=11, C=01) -> x[3]=1, x[4]=1, x[1]=0, x[2]=1
    // (R=10, C=00) -> x[3]=1, x[4]=0, x[1]=0, x[2]=0
    // (R=10, C=01) -> x[3]=1, x[4]=0, x[1]=0, x[2]=1

    // R=11 OR R=10: x[3] is 1, and x[4] is don't care?
    // Let's re-evaluate:
    // R=11, C=00/01 -> x[3]=1, x[4]=1, x[1]=0, x[2]=0/1
    // R=10, C=00/01 -> x[3]=1, x[4]=0, x[1]=0, x[2]=0/1
    // Combined: x[3]=1, x[1]=0 (x[2] can be 0 or 1), x[4] can be 0 or 1.
    // So if x[3]=1 and x[1]=0, f=1.
    
    // R=01, C=11 -> x[3]=0, x[4]=1, x[1]=1, x[2]=1
    // Total: f = (x[3] & ~x[1]) | (~x[3] & x[4] & x[1] & x[2])
    
    // Wait, the testbench mismatch suggests my interpretation of input x[3:0] might be different.
    // If x = {x[3], x[4], x[1], x[2]} is NOT the correct bit order for input x[3:0].
    // Usually inputs are ordered {x[3], x[2], x[1], x[0]}.
    // Let's re-map based on x[3], x[2], x[1], x[0]:
    // Row x[3]x[4] -> Row x[3]x[2]
    // Col x[1]x[2] -> Col x[1]x[0]

    // New Mapping:
    // R = x[3:2], C = x[1:0]
    // R\C | 00 | 01 | 11 | 10
    // 00  |  d | 0  | d  | d
    // 01  |  0 | d  | 1  | 0
    // 11  |  1 | 1  | d  | d
    // 10  |  1 | 1  | 0  | d
    
    // (R=01, C=11) -> 0111 (7)
    // (R=11, C=00) -> 1100 (12)
    // (R=11, C=01) -> 1101 (13)
    // (R=10, C=00) -> 1000 (8)
    // (R=10, C=01) -> 1001 (9)

    // Simplified:
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1])
    
    assign f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1]);

endmodule
