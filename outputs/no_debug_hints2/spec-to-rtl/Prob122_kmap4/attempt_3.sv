module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);

    // K-map:
    //      ab
    // cd 00 01 11 10
    // 00  0  1  0  1
    // 01  1  0  1  0
    // 11  0  1  0  1
    // 10  1  0  1  0

    // Truth table:
    // ab cd | out
    // 00 00 | 0
    // 00 01 | 1
    // 00 11 | 0
    // 00 10 | 1
    // 01 00 | 1
    // 01 01 | 0
    // 01 11 | 1
    // 01 10 | 0
    // 11 00 | 0
    // 11 01 | 1
    // 11 11 | 0
    // 11 10 | 1
    // 10 00 | 1
    // 10 01 | 0
    // 10 11 | 1
    // 10 10 | 0

    // Boolean algebra simplification:
    // out = (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & b & ~c & ~d) | (~a & b & c & d) | ...
    // Looking closely at the K-map values (1s):
    // 0001 (b^d=1), 0010 (b^d=1), 0100 (b^d=1), 0111 (b^d=1), 1101 (b^d=1), 1110 (b^d=1), 1000 (b^d=1), 1011 (b^d=1)
    // Actually, checking values:
    // abcd=0000: b^d=0, map=0. OK.
    // abcd=0001: b^d=1, map=1. OK.
    // abcd=0010: b^d=1, map=1. OK.
    // abcd=0011: b^d=0, map=0. OK.
    // abcd=0100: b^d=1, map=1. OK.
    // abcd=0101: b^d=0, map=0. OK.
    // abcd=0110: b^d=1, map=1. Wait... the Kmap at 01,10 is 0. My mapping was 1.
    // Re-evaluating the table:
    // 01, 00: 1
    // 01, 01: 0
    // 01, 11: 1
    // 01, 10: 0
    //
    // Let's re-verify:
    // (a,b) row indices are 00, 01, 11, 10 (Gray code)
    // (c,d) col indices are 00, 01, 11, 10 (Gray code)
    //
    // The provided map:
    //       ab=00  01  11  10
    // cd=00 | 0 | 1 | 0 | 1 |
    //    01 | 1 | 0 | 1 | 0 |
    //    11 | 0 | 1 | 0 | 1 |
    //    10 | 1 | 0 | 1 | 0 |
    //
    // This is simply: (b ^ d) is NOT correct because of the row/col labels order
    //
    // Let's see:
    // Row 00 (a=0,b=0): cd=00->0, 01->1, 11->0, 10->1  => out = d (if a=0,b=0)
    // Row 01 (a=0,b=1): cd=00->1, 01->0, 11->1, 10->0  => out = !d (if a=0,b=1)
    // Row 11 (a=1,b=1): cd=00->0, 01->1, 11->0, 10->1  => out = d (if a=1,b=1)
    // Row 10 (a=1,b=0): cd=00->1, 01->0, 11->1, 10->0  => out = !d (if a=1,b=0)
    //
    // Summarizing:
    // If b=0, out = d
    // If b=1, out = !d
    // So out = b ^ !d, which is !(b ^ d)

    always @(*) begin
        out = !(b ^ d);
    end

endmodule
