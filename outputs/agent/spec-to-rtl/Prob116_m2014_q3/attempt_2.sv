module TopModule (
    input [3:0] x,
    output f
);
    // Based on K-map:
    // x[1]x[2] (x[3]x[2] in logic)
    // x[3]x[4] (x[1]x[0] in logic)

    // Table:
    // x3 x2 x1 x0 | f
    // 0  0  0  0  | d
    // 0  0  0  1  | 0
    // 0  0  1  1  | d
    // 0  0  1  0  | d
    // 0  1  0  0  | 0
    // 0  1  0  1  | d
    // 0  1  1  1  | 1
    // 0  1  1  0  | 0
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  1  | d
    // 1  1  1  0  | d
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  1  | 0
    // 1  0  1  0  | d

    // Let's re-map K-map based on variable names given in task (x is 4 bits)
    // x[0] corresponds to x[1] in K-map (x[3] in verilog index)
    // x[1] corresponds to x[2]
    // x[2] corresponds to x[3]
    // x[3] corresponds to x[4]

    // My logic was using (x[3] & ~x[1]) which was wrong due to mismatch in bit interpretation.
    // Let's define the logic directly based on the k-map:
    // rows (x1,x2): 00 01 11 10
    // cols (x3,x4): 00 01 11 10
    // f(x1,x2,x3,x4)

    // Map:
    // x1x2 x3x4 | f
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

    // Simplified Boolean function:
    // f = (~x1 & x2 & x3 & x4) | (x1 & ~x3) | (x1 & x2)
    // Actually:
    // f = (x1 & ~x3) | (x2 & x3 & x4)
    // Let's test this.

    wire x1 = x[3];
    wire x2 = x[2];
    wire x3 = x[1];
    wire x4 = x[0];

    assign f = (x1 & ~x3) | (x2 & x3 & x4);

endmodule