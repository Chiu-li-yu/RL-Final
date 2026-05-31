module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-read the K-map carefully:
    // x[3]x[4] is row (00, 01, 11, 10)
    // x[1]x[2] is col (00, 01, 11, 10)
    
    // Maybe x[4] and x[2] are not the LSBs?
    // Maybe the input x is [x3, x4, x1, x2] = x[3], x[2], x[1], x[0]?
    // Let's map it:
    // K-map row bits: x[3], x[2]
    // K-map col bits: x[1], x[0]
    
    // K-map (x3 x2 | x1 x0):
    //      00 01 11 10
    // 00 | d  0  d  d  (0000, 0001, 0011, 0010)
    // 01 | 0  d  1  0  (0100, 0101, 0111, 0110)
    // 11 | 1  1  d  d  (1100, 1101, 1111, 1110)
    // 10 | 1  1  0  d  (1000, 1001, 1011, 1010)
    
    // Logic:
    // 1 at:
    // 0111 (7)
    // 1100 (12)
    // 1101 (13)
    // 1000 (8)
    // 1001 (9)
    
    // Let's try: f = (x[3] & ~x[1]) | (~x[3] & x[2] & x[1] & x[0])
    // wait, I tried that. Maybe the 1s are at different places?
    // Let's look at the map indices again:
    // Row 00, Col 00: d
    // Row 00, Col 01: 0
    // Row 00, Col 11: d
    // Row 00, Col 10: d
    
    // Row 01, Col 00: 0
    // Row 01, Col 01: d
    // Row 01, Col 11: 1
    // Row 01, Col 10: 0
    
    // Row 11, Col 00: 1
    // Row 11, Col 01: 1
    // Row 11, Col 11: d
    // Row 11, Col 10: d
    
    // Row 10, Col 00: 1
    // Row 10, Col 01: 1
    // Row 10, Col 11: 0
    // Row 10, Col 10: d
    
    // Everything looks consistent with:
    // f = 1 if:
    // (x3, x2) = 01 and (x1, x0) = 11
    // (x3, x2) = 11 and (x1, x0) = 00 or 01
    // (x3, x2) = 10 and (x1, x0) = 00 or 01
    
    // f = (~x3 & x2 & x1 & x0) | (x3 & ~x1 & ~x2) | (x3 & ~x1 & x2)
    // f = (~x3 & x2 & x1 & x0) | (x3 & ~x1)
    
    // This is the same. Maybe x indices are not 3,2,1,0?
    // What if it is x[0], x[1], x[2], x[3]?
    // Let's try x[0] as MSB.
    
    assign f = (x[0] & ~x[2]) | (~x[0] & x[1] & x[2] & x[3]);
    
endmodule
