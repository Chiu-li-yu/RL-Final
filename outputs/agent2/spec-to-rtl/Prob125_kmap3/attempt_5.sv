module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);
    // Let's re-read the K-Map carefully:
    // Row 00 (cd=00): col 00=0, 01=d, 10=1, 11=1
    // Row 01 (cd=01): col 00=0, 01=0, 10=d, 11=d
    // Row 11 (cd=11): col 00=0, 01=1, 10=1, 11=1
    // Row 10 (cd=10): col 00=0, 01=1, 10=1, 11=1

    // Wait, the K-map provided was:
    //              ab
    //   cd   01  00  10  11
    //   00 | d | 0 | 1 | 1 |
    //   01 | 0 | 0 | d | d |
    //   11 | 0 | 1 | 1 | 1 |
    //   10 | 0 | 1 | 1 | 1 |

    // Let's re-map using cd as row and ab as column:
    // Rows (cd): 00, 01, 11, 10
    // Cols (ab): 00, 01, 10, 11
    // Map table:
    //          ab: 00  01  10  11
    // cd=00:        0   d   1   1
    // cd=01:        0   0   d   d
    // cd=11:        1   0   1   1
    // cd=10:        1   0   1   1

    // Redoing Truth Table:
    // c d a b | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | d
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | d
    // 0 1 1 1 | d
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 0
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1

    // Trying out = (a & ~b) | (c & a) ... this is guessing.
    // Let's re-verify the K-Map indexing again.
    // The columns are labeled 01, 00, 10, 11.
    // This is NOT standard Gray code (00, 01, 11, 10).
    // Let's map column ab strictly:
    // ab=01 -> Col 1
    // ab=00 -> Col 2
    // ab=10 -> Col 3
    // ab=11 -> Col 4
    
    // cd=00 row: (ab=01)d, (ab=00)0, (ab=10)1, (ab=11)1
    // cd=01 row: (ab=01)0, (ab=00)0, (ab=10)d, (ab=11)d
    // cd=11 row: (ab=01)0, (ab=00)1, (ab=10)1, (ab=11)1
    // cd=10 row: (ab=01)0, (ab=00)1, (ab=10)1, (ab=11)1

    // Let's build a map:
    // a b | c d | out
    // 0 1 | 0 0 | d
    // 0 0 | 0 0 | 0
    // 1 0 | 0 0 | 1
    // 1 1 | 0 0 | 1
    // 0 1 | 0 1 | 0
    // 0 0 | 0 1 | 0
    // 1 0 | 0 1 | d
    // 1 1 | 0 1 | d
    // 0 1 | 1 1 | 0
    // 0 0 | 1 1 | 1
    // 1 0 | 1 1 | 1
    // 1 1 | 1 1 | 1
    // 0 1 | 1 0 | 0
    // 0 0 | 1 0 | 1
    // 1 0 | 1 0 | 1
    // 1 1 | 1 0 | 1
    
    // Simplification:
    // out = 1 when (a=1) OR (b=0 & c=1) ... let's check
    // (a=1) -> 0 0 1 0, 0 0 1 1, 1 1 1 0, 1 1 1 1, 1 0 1 0, 1 0 1 1 ... this seems to cover most 1s.
    
    always @(*) begin
        out = a | (~b & c);
    end
endmodule
