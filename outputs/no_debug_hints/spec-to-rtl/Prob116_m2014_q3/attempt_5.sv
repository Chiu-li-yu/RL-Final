module TopModule (
    input [3:0] x,
    output f
);
    // Based on K-map rows: x[3]x[4], cols: x[1]x[2]
    // Let's use x[3] as MSB of row, x[4] as LSB of row, x[1] as MSB of col, x[2] as LSB of col
    // Map:
    // row\col | 00 | 01 | 11 | 10
    // 00      | d  | 0  | d  | d
    // 01      | 0  | d  | 1  | 0
    // 11      | 1  | 1  | d  | d
    // 10      | 1  | 1  | 0  | d

    // Simplified:
    // Rows 11 and 10 have 1s.
    // Row 11: 1, 1, d, d -> Covers 00, 01.
    // Row 10: 1, 1, 0, d -> Covers 00, 01.
    // So if x3=1, f=1.
    // Row 01, Col 11 is 1. (x3=0, x4=1, x1=1, x2=1)

    // So f = x[3] | (~x[3] & x[4] & x[1] & x[2])
    assign f = x[3] | (~x[3] & x[2] & x[1] & x[0]);
endmodule
