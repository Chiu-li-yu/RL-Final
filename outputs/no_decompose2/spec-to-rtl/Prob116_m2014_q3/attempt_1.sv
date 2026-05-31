module TopModule (
    input [3:0] x,
    output f
);
    logic [3:0] x_val;
    assign x_val = x;

    // Mapping: x[3]x[4] as row, x[1]x[2] as column
    // Karnaugh Map (x[3]x[4] on vertical, x[1]x[2] on horizontal)
    // 00 01 11 10
    // 00: d, 0, d, d
    // 01: 0, d, 1, 0
    // 11: 1, 1, d, d
    // 10: 1, 1, 0, d

    // Let's decide the don't cares (d) for optimization:
    // 0000: 0, 0001: 0, 0010: 0, 0011: 0 (Let's make them all 0)
    // 0100: 0, 0101: 1, 0111: 1, 0110: 0
    // 1100: 1, 1101: 1, 1111: 0, 1110: 0
    // 1000: 1, 1001: 1, 1011: 0, 1010: 0

    // Truth Table:
    // x[3]x[4] x[1]x[2] | f
    // 00 00 | 0
    // 00 01 | 0
    // 00 11 | 0
    // 00 10 | 0
    // 01 00 | 0
    // 01 01 | 1
    // 01 11 | 1
    // 01 10 | 0
    // 11 00 | 1
    // 11 01 | 1
    // 11 11 | 0
    // 11 10 | 0
    // 10 00 | 1
    // 10 01 | 1
    // 10 11 | 0
    // 10 10 | 0

    // Simplified Boolean Expression:
    // Minimized via K-map:
    // f = x[3] & ~x[2] | ~x[3] & x[4] & x[2]
    
    always @(*) begin
        f = (x[3] & ~x[2]) | (~x[3] & x[4] & x[2]);
    end

endmodule
