module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-examine the K-Map carefully.
    // The problem statement says:
    // input  x (4 bits)
    // Map labels:
    // row: x[3]x[4]  (wait, is x[4] a bit?)
    // "input x (4 bits)" -> bits are usually x[3], x[2], x[1], x[0].
    // If the map uses x[3] and x[4], it might mean x[3] and x[2] are the rows, and x[1] and x[0] are the cols.
    // Wait, the K-map labels:
    // x[3]x[4]
    // x[1]x[2]
    // Maybe x[3] is the first bit, x[4] is the second bit... wait, 4 bits are x[3], x[2], x[1], x[0].
    // Let's assume:
    // Row bits: x[3] and x[2]
    // Col bits: x[1] and x[0]
    // K-map:
    //         x[1]x[0]
    // x[3]x[2] 00 01 11 10
    // 00     | d| 0| d| d|
    // 01     | 0| d| 1| 0|
    // 11     | 1| 1| d| d|
    // 10     | 1| 1| 0| d|
    
    // Truth table:
    // x3 x2 x1 x0 | f
    // 0  0  0  0  | d (0)
    // 0  0  0  1  | 0
    // 0  0  1  1  | d (0)
    // 0  0  1  0  | d (0)
    
    // 0  1  0  0  | 0
    // 0  1  0  1  | d (1)
    // 0  1  1  1  | 1
    // 0  1  1  0  | 0
    
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  1  | d (0)
    // 1  1  1  0  | d (0)
    
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  1  | 0
    // 1  0  1  0  | d (0)

    // Let's re-evaluate the map with the assumption of which 'd's to pick.
    // Maybe I should treat x as [x3, x2, x1, x0]?
    // Let's use the K-Map to find f again.
    
    // K-map f:
    // 0000:0, 0001:0, 0010:0, 0011:0
    // 0100:0, 0101:1, 0110:0, 0111:1
    // 1000:1, 1001:1, 1010:0, 1011:0
    // 1100:1, 1101:1, 1110:0, 1111:0
    
    // Using K-Map solver for:
    // 0 0 0 0
    // 0 1 0 1
    // 1 1 0 0
    // 1 1 0 0
    // That's 16 entries:
    // f(0,0,0,0) = 0
    // f(0,0,0,1) = 0
    // f(0,0,1,0) = 0
    // f(0,0,1,1) = 0
    // f(0,1,0,0) = 0
    // f(0,1,0,1) = 1
    // f(0,1,1,0) = 0
    // f(0,1,1,1) = 1
    // f(1,0,0,0) = 1
    // f(1,0,0,1) = 1
    // f(1,0,1,0) = 0
    // f(1,0,1,1) = 0
    // f(1,1,0,0) = 1
    // f(1,1,0,1) = 1
    // f(1,1,1,0) = 0
    // f(1,1,1,1) = 0
    
    // Karnaugh Map:
    // x3x2 \ x1x0 | 00 | 01 | 11 | 10
    // 00          | 0  | 0  | 0  | 0
    // 01          | 0  | 1  | 1  | 0
    // 11          | 1  | 1  | 0  | 0
    // 10          | 1  | 1  | 0  | 0
    
    // Grouping:
    // (01,01) and (01,11) -> x3=0, x2=1, x1=1
    // (11,00) and (11,01) and (10,00) and (10,01) -> x3=1, x1=0
    
    // So f = (~x3 & x2 & x1) | (x3 & ~x1)
    
    assign f = (~x[3] & x[2] & x[1]) | (x[3] & ~x[1]);

endmodule