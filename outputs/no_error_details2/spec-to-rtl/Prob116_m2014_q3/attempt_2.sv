module TopModule(
    input [3:0] x,
    output f
);
    // x[3] is MSB, x[0] is LSB
    // Map indices: 
    // Row x[3]x[2], Col x[1]x[0]
    // 00: d 0 d d
    // 01: 0 d 1 0
    // 11: 1 1 d d
    // 10: 1 1 0 d
    
    // Choose d:
    // 0000: 0, 0001: 0, 0010: 0, 0011: 0
    // 0100: 0, 0101: 0, 0110: 0, 0111: 1
    // 1100: 1, 1101: 1, 1110: 1, 1111: 1
    // 1000: 1, 1001: 1, 1010: 0, 1011: 0

    // K-map:
    //      x1 x0
    // x3x2 00 01 11 10
    // 00 | 0  0  0  0
    // 01 | 0  0  1  0
    // 11 | 1  1  1  1
    // 10 | 1  1  0  0

    // Karnaugh map groupings:
    // 1. x3 & x2 (Group of 4: 1100, 1101, 1111, 1110)
    // 2. x3 & ~x1 & ~x0 (Group of 2: 1000, 1100) -> Wait, 1100 is covered by group 1.
    // 3. x3 & ~x1 & ~x0 (Group of 2: 1000, 1001 is better)
    // 4. x2 & x1 & x0 (Group of 2: 0111, 1111) -> 1111 covered.

    // Grouping again:
    // - x3 (row 11 and row 10): 
    //   Row 11: x3x2 (all 1s)
    //   Row 10: x3&~x2&~x1 (1000, 1001)
    // - x2&x1&x0 (0111, 1111)

    // Simplified:
    // f = (x3 & x2) | (x3 & ~x1 & ~x0) | (x2 & x1 & x0)

    assign f = (x[3] & x[2]) | (x[3] & ~x[1] & ~x[0]) | (x[2] & x[1] & x[0]);
endmodule
