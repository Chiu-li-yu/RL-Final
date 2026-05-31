module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh map:
    //      ab
    // cd  00 01 11 10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |

    // Minterms where output is 1:
    // (a,b,c,d)
    // 0,0,0,0 (0000) -> 1
    // 0,1,0,0 (0100) -> 1
    // 1,0,0,0 (1000) -> 1
    // 0,0,0,1 (0001) -> 1
    // 1,0,0,1 (1001) -> 1
    // 1,1,1,1 (1111) -> 1
    // 0,1,1,1 (0111) -> 1
    // 0,0,1,0 (0010) -> 1
    // 0,1,1,0 (0110) -> 1
    // 1,1,1,0 (1110) -> 0 (Wait, re-reading the K-map)

    // Re-mapping:
    // row/col (cd/ab)
    // 0000: 1
    // 0100: 1
    // 1100: 0
    // 1000: 1
    // 0001: 1
    // 0101: 0
    // 1101: 0
    // 1001: 1
    // 0011: 0
    // 0111: 1
    // 1111: 1
    // 1011: 1
    // 0010: 1
    // 0110: 1
    // 1110: 0
    // 1010: 0

    // Karnaugh map table:
    // cd\ab  00 01 11 10
    // 00     1  1  0  1
    // 01     1  0  0  1
    // 11     0  1  1  1
    // 10     1  1  0  0

    // Sum of products (minterms):
    // m(0, 1, 2, 4, 6, 7, 8, 9, 11, 14, 15) <- Check row 3 (cd=11) col 01 is 1, col 11 is 1, col 10 is 1. Wait.
    // cd=00: 1, 1, 0, 1 -> 0, 1, 3 (idx 0000, 0100, 1000)
    // cd=01: 1, 0, 0, 1 -> 0, 3 (idx 0001, 1001)
    // cd=11: 0, 1, 1, 1 -> 1, 2, 3 (idx 0111, 1111, 1011)
    // cd=10: 1, 1, 0, 0 -> 0, 1 (idx 0010, 0110)

    // Using Logic simplification:
    logic result;
    always @(*) begin
        result = (~c & ~d & ~a & ~b) | (~c & ~d & ~a & b) | (~c & ~d & a & ~b) |
                 (~c & d & ~a & ~b) | (~c & d & a & ~b) |
                 (c & d & ~a & b) | (c & d & a & b) | (c & d & a & ~b) |
                 (c & ~d & ~a & ~b) | (c & ~d & ~a & b);
    end

    assign out = result;
endmodule
