module TopModule (
    input [3:0] x,
    output f
);
    // x input is 4 bits: x[3] x[2] x[1] x[0]
    // Task:
    // x[1]x[2] (high bits)
    // x[3]x[4] (low bits)
    
    // Mapping:
    // x[1] is x[3]
    // x[2] is x[2]
    // x[3] is x[1]
    // x[4] is x[0]

    // K-map table (rows: x1x2, cols: x3x4):
    //    00 01 11 10
    // 00  d  0  d  d
    // 01  0  d  1  0
    // 11  1  1  d  d
    // 10  1  1  0  d

    // Let's set don't cares (d) to:
    // 00 00 -> 0
    // 00 11 -> 0
    // 00 10 -> 0
    // 01 01 -> 1
    // 11 11 -> 1
    // 11 10 -> 1
    // 10 10 -> 0
    
    // New truth table:
    // x1 x2 x3 x4 | f
    // 0  0  0  0  | 0
    // 0  0  0  1  | 0
    // 0  0  1  0  | 0
    // 0  0  1  1  | 0
    // 0  1  0  0  | 0
    // 0  1  0  1  | 1
    // 0  1  1  0  | 0
    // 0  1  1  1  | 1
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  0  | 0
    // 1  0  1  1  | 0
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  0  | 1
    // 1  1  1  1  | 1

    // Logic for f:
    // f = (x1 & ~x3) | (x2 & x3 & x4)
    // f = x[3] & ~x[1] | x[2] & x[1] & x[0]
    
    assign f = (x[3] & ~x[1]) | (x[2] & x[1] & x[0]);
endmodule