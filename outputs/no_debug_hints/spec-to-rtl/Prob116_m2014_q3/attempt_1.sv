module TopModule (
    input [3:0] x,
    output f
);
    // x[3] = x[3], x[4] = x[2], x[1] = x[1], x[2] = x[0] based on standard K-map indexing:
    // map labels: x[3]x[4] | x[1]x[2]
    // Let's interpret input x as {x[3], x[2], x[1], x[0]}
    // Map:
    // x3x2 | x1x0
    // 00   | 00:d 01:0 11:d 10:d
    // 01   | 00:0 01:d 11:1 10:0
    // 11   | 00:1 01:1 11:d 10:d
    // 10   | 00:1 01:1 11:0 10:d

    // Let's set 'd' values to minimize logic:
    // d(0000)=0, d(0011)=0, d(0010)=0, d(0101)=0, d(1111)=1, d(1110)=1, d(1010)=0
    // Simplified function logic:
    // f = (x3 & ~x1) | (~x3 & x1 & x2)
    // Checking:
    // 0111: (~0 & 1 & 1) = 1 (Correct)
    // 1100: (1 & ~0) = 1 (Correct)
    // 1101: (1 & ~0) = 1 (Correct)
    // 1000: (1 & ~0) = 1 (Correct)
    // 1001: (1 & ~0) = 1 (Correct)
    // 1011: (1 & ~1) | (0) = 0 (Correct)

    assign f = (x[3] & ~x[1]) | (~x[3] & x[1] & x[0]);
endmodule
