module TopModule (
    input [3:0] x,
    output f
);
    // K-map labels:
    // x3 x4 (rows), x1 x2 (cols)
    // input is 4 bits, assumed: x[3], x[2], x[1], x[0]
    // If x[3]x[4] map to x[3]x[2] and x[1]x[2] map to x[1]x[0]:
    // Map:
    // x3x2 | 00 01 11 10
    // 00   | d  0  d  d
    // 01   | 0  d  1  0
    // 11   | 1  1  d  d
    // 10   | 1  1  0  d

    // Let's use logic mapping x3, x2, x1, x0:
    // x3x2\x1x0 | 00 01 11 10
    // 00         | d  0  d  d
    // 01         | 0  d  1  0
    // 11         | 1  1  d  d
    // 10         | 1  1  0  d

    // Let's assign d:
    // d(0000)=0, d(0011)=0, d(0010)=0, d(0101)=0, d(1111)=1, d(1110)=1, d(1010)=0
    // Map:
    // 0000:0, 0001:0, 0011:0, 0010:0
    // 0100:0, 0101:0, 0111:1, 0110:0
    // 1100:1, 1101:1, 1111:1, 1110:1
    // 1000:1, 1001:1, 1011:0, 1010:0

    // f = x[3] | (x[2] & x[1] & ~x[0])
    assign f = x[3] | (x[2] & x[1] & ~x[0]);
endmodule
