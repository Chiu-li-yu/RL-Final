module TopModule (
    input [3:0] x,
    output f
);
    // K-map:
    // row: x[1]x[2] (x[3]x[2] in indices)
    // col: x[3]x[4] (x[1]x[0] in indices)
    // Map:
    // x3x2 x1x0 | f
    // 00 00 | d
    // 00 01 | 0
    // 00 11 | d
    // 00 10 | d
    // 01 00 | 0
    // 01 01 | d
    // 01 11 | 1
    // 01 10 | 0
    // 11 00 | 1
    // 11 01 | 1
    // 11 11 | d
    // 11 10 | d
    // 10 00 | 1
    // 10 01 | 1
    // 10 11 | 0
    // 10 10 | d

    // Try f = (x[3] & ~x[1]) | (~x[3] & x[2] & x[1] & x[0])
    // The previous 17 mismatches might be from the 'd' assignments.
    // Let's try to map the 1s and 0s exactly and leave d as a condition
    // f = 1 if: (x3=0, x2=1, x1=1, x0=1) OR (x3=1, x2=1) OR (x3=1, x2=0) ...
    // Looking at the map:
    // When x[3]=1: f=1 for (00, 01), f=d for (11, 10)
    // So if x[3]=1, f=1 (if we set d to 1).
    // When x[3]=0, x[2]=1: f=1 for (11), f=0 for (00, 10), f=d for (01)
    
    // Let's try:
    assign f = x[3] | (x[2] & x[1]);

endmodule