module TopModule (
    input [3:0] x,
    output f
);
    // x[3] is MSB (x[1] in K-map description), x[2] is next, x[1] is next, x[0] is LSB (x[4] in K-map description)
    // Based on K-map:
    // row: x[3]x[2] (00, 01, 11, 10)
    // col: x[1]x[0] (00, 01, 11, 10)
    // Map indices (binary):
    // 0000: d, 0001: 0, 0011: d, 0010: d
    // 0100: 0, 0101: d, 0111: 1, 0110: 0
    // 1100: 1, 1101: 1, 1111: d, 1110: d
    // 1000: 1, 1001: 1, 1011: 0, 1010: d

    // Assigning don't care to make the logic as simple as possible
    // Let's pick values to simplify:
    // 0000 -> 0, 0011 -> 0, 0010 -> 0
    // 0101 -> 0
    // 1111 -> 0, 1110 -> 0
    // 1010 -> 0

    // Truth Table after choosing d:
    // 0000: 0
    // 0001: 0
    // 0010: 0
    // 0011: 0
    // 0100: 0
    // 0101: 0
    // 0110: 0
    // 0111: 1
    // 1000: 1
    // 1001: 1
    // 1010: 0
    // 1011: 0
    // 1100: 1
    // 1101: 1
    // 1110: 0
    // 1111: 0

    // Logic implementation:
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[2] & ~x[1] & ~x[0]) | (x[3] & ~x[2] & ~x[1] & x[0]) | (x[3] & x[2] & ~x[1] & ~x[0]) | (x[3] & x[2] & ~x[1] & x[0])
    // Simplifies to:
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[2] & ~x[1]) | (x[3] & x[2] & ~x[1])
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1])

    assign f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1]);

endmodule