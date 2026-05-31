module TopModule (
    input [3:0] x,
    output f
);
    // Let's assume the rows are x[3], x[2] and cols are x[1], x[0]
    // The k-map:
    //      x1x0 00  01  11  10
    // x3x2
    // 00      d   0   d   d  -> 0,0,0,0
    // 01      0   d   1   0  -> 0,0,1,0
    // 11      1   1   d   d  -> 1,1,0,0
    // 10      1   1   0   d  -> 1,1,0,0
    
    // Truth table:
    // x3 x2 x1 x0 | f
    // 0  0  0  0  | 0
    // 0  0  0  1  | 0
    // 0  0  1  0  | 0
    // 0  0  1  1  | 0
    // 0  1  0  0  | 0
    // 0  1  0  1  | 0
    // 0  1  1  0  | 1
    // 0  1  1  1  | 0
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  0  | 0
    // 1  1  1  1  | 0
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  0  | 0
    // 1  0  1  1  | 0

    logic f_val;
    always @(*) begin
        f_val = (~x[3] & x[2] & x[1] & ~x[0]) | (x[3] & ~x[1] & ~x[0]);
    end

    assign f = f_val;
endmodule