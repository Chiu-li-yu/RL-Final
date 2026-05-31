module TopModule (
    input [3:0] x,
    output f
);
    // x[3] x[2] | x[1] x[0]
    // 00: 0, 0, 0, 0
    // 01: 0, 0, 1, 0
    // 11: 1, 1, 0, 0
    // 10: 1, 1, 0, 0

    // Re-evaluating K-Map from provided strings:
    // "x[3]x[4]" (rows) vs "x[1]x[2]" (cols)
    // Actually, x is 4 bits: x[3], x[2], x[1], x[0].
    // Let's interpret the K-map carefully:
    // Rows (x[3]x[2]):
    // 00: d, 0, d, d
    // 01: 0, d, 1, 0
    // 11: 1, 1, d, d
    // 10: 1, 1, 0, d

    // Column headers are x[1]x[0].
    // Minterms where f = 1:
    // (x3, x2, x1, x0)
    // 0110 (row 1, col 3 - wait, row 1 is 01, col 3 is 10): 01 10 -> 1
    // 1100 (row 2, col 0 - wait, row 2 is 11, col 0 is 00): 11 00 -> 1
    // 1101 (row 2, col 1 - wait, row 2 is 11, col 1 is 01): 11 01 -> 1
    // 1000 (row 3, col 0 - wait, row 3 is 10, col 0 is 00): 10 00 -> 1
    // 1001 (row 3, col 1 - wait, row 3 is 10, col 1 is 01): 10 01 -> 1

    logic f_val;
    always @(*) begin
        // Truth table (d = 1 for maximal simplification):
        // (x3, x2, x1, x0)
        // 0000: 1 (d)
        // 0001: 0
        // 0010: 1 (d)
        // 0011: 1 (d)
        // 0100: 0
        // 0101: 1 (d)
        // 0110: 1
        // 0111: 0
        // 1100: 1
        // 1101: 1
        // 1110: 1 (d)
        // 1111: 1 (d)
        // 1000: 1
        // 1001: 1
        // 1010: 0
        // 1011: 1 (d)

        // Using K-map with d=1:
        // f = x3 + x2*x1 + ~x2*~x1*~x0
        f_val = x[3] | (x[2] & x[1]) | (~x[2] & ~x[1] & ~x[0]);
    end

    assign f = f_val;

endmodule