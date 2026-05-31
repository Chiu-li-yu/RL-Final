module TopModule (
    input [3:0] x,
    output f
);
    // K-map from problem:
    //    00 01 11 10 (x2, x3)
    // 00  d  0  d  d
    // 01  0  d  1  0
    // 11  1  1  d  d
    // 10  1  1  0  d

    // Let's interpret input carefully. Usually x[3] is MSB.
    // Let's try matching the map directly with indices:
    // x[3]x[2] (rows)
    // x[1]x[0] (cols)

    // Map again:
    // x[3]x[2] x[1]x[0] | f
    // 00 00 -> d
    // 00 01 -> 0
    // 00 11 -> d
    // 00 10 -> d
    // 01 00 -> 0
    // 01 01 -> d
    // 01 11 -> 1
    // 01 10 -> 0
    // 11 00 -> 1
    // 11 01 -> 1
    // 11 11 -> d
    // 11 10 -> d
    // 10 00 -> 1
    // 10 01 -> 1
    // 10 11 -> 0
    // 10 10 -> d

    // Try f = x[3] | (x[2] & x[1])
    assign f = x[3] | (x[2] & x[1]);

endmodule