module TopModule (
    input [3:0] x,
    output f
);
    // x[3]x[2] (rows), x[1]x[0] (cols)
    // 00: d, 0, d, d
    // 01: 0, d, 1, 0
    // 11: 1, 1, d, d
    // 10: 1, 1, 0, d

    // Truth Table:
    // x3 x2 x1 x0 | f
    // 0  0  0  0  | d (0)
    // 0  0  0  1  | 0
    // 0  0  1  0  | d (0)
    // 0  0  1  1  | d (0)
    // 0  1  0  0  | 0
    // 0  1  0  1  | d (0)
    // 0  1  1  0  | 1
    // 0  1  1  1  | 0
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  0  | d (0)
    // 1  1  1  1  | d (0)
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  0  | 0
    // 1  0  1  1  | d (0)

    // Using K-Map simplification with d=0:
    // f = x[3] & ~x[2] & ~x[1] | x[3] & x[2] & ~x[1] | ~x[3] & x[2] & x[1] & ~x[0]
    // Simplified:
    // f = x[3] & ~x[1] | ~x[3] & x[2] & x[1] & ~x[0]

    logic f_val;
    always @(*) begin
        f_val = (x[3] & ~x[1]) | (~x[3] & x[2] & x[1] & ~x[0]);
    end

    assign f = f_val;

endmodule