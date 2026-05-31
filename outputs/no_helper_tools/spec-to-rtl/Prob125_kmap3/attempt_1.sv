module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map layout:
    //      ab
    // cd  00 01 10 11
    // 00  0  d  1  1
    // 01  0  0  d  d
    // 11  1  0  1  1
    // 10  1  0  1  1
    // Note: The input order is cd row, ab col.
    // The provided K-map:
    //       ab
    // cd   01 00 10 11
    // 00 | d | 0 | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 0 | 1 | 1 | 1 |

    // Let's map it to (a,b,c,d) = (ab, cd)
    // Truth table:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | d -> 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 0
    // 1 0 0 0 | 1
    // 1 0 0 1 | d -> 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | d -> 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    always @(*) begin
        // Simplified Logic:
        // By setting all d=1, we get:
        // out = a | (~b & c) | (b & ~c & ~d)
        // Let's verify with the map.
        // A simple K-map reduction:
        // If we set all 'd' = 1:
        // 1s are at: 0010, 0011, 0110, 1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111
        // This covers a lot.
        // Logic: out = a | (~b & c) | (b & ~c & ~d) ...
        // Actually, just reading the map:
        // out = a | (c & ~b) | (~c & ~d & b)
        
        // Wait, looking at the table again:
        // row cd=00: col 01=d, 00=0, 10=1, 11=1 -> (a=1 OR (b=1 & c=0 & d=0))
        // row cd=01: col 01=0, 00=0, 10=d, 11=d
        // row cd=11: col 01=0, 00=1, 10=1, 11=1
        // row cd=10: col 01=0, 00=1, 10=1, 11=1
        
        // Let's use standard SOP:
        out = a | (~b & c) | (b & ~c & ~d);
    end

endmodule
