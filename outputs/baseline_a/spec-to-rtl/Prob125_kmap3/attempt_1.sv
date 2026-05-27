module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Karnaugh map table:
    //      ab
    // cd | 00 | 01 | 11 | 10
    // 00 |  0 |  d |  1 |  1
    // 01 |  0 |  0 |  d |  d
    // 11 |  1 |  0 |  1 |  1
    // 10 |  1 |  0 |  1 |  1

    // Map:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | d -> 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 0
    // 1 0 0 0 | 1
    // 1 0 0 1 | d -> 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | d -> 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    // Truth Table simplified:
    // out = (~a & ~b & c) | (a) | (b & ~c & ~d) ... let's derive manually.

    // Grouping 1s:
    // (a) covers (1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111)
    // (b & ~c) covers (0100, 0110, 1100, 1110)
    // (~a & ~b & c) covers (0010, 0011)

    // Using don't-care (d):
    // Let's set all d = 1.
    // 0001 = 1
    // 1001 = 1
    // 1101 = 1
    // 0111 = 1 (Wait, looking at the table: 01 11 is 'd')

    // Re-evaluating K-map with d as 1:
    // cd\ab 00 01 11 10
    // 00    0  1  1  1
    // 01    0  0  1  1
    // 11    1  0  1  1
    // 10    1  1  1  1

    // Minimized logic:
    // out = a | b | (~a & ~b & c)
    // let's check:
    // a=1 -> out=1 (covers 8)
    // b=1 -> out=1 (covers 4, already covered some)
    // a=0, b=0, c=1 -> out=1 (covers 0010, 0011)
    // Looks correct.

    always @(*) begin
        out = a | b | (~a & ~b & c);
    end

endmodule
