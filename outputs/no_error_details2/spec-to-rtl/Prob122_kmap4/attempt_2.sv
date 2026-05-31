module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map Table (rows: cd, cols: ab)
    //    ab
    // cd 00 01 11 10
    // 00 0  1  0  1
    // 01 1  0  1  0
    // 11 0  1  0  1
    // 10 1  0  1  0

    // Mapping inputs to table:
    // (a,b,c,d)
    // Row/Col Index:
    // cd = {c,d}
    // ab = {a,b}

    // Let's list where out = 1:
    // (a,b,c,d)
    // 0001 (ab=00, cd=01)
    // 0100 (ab=01, cd=00)
    // 1000 (ab=10, cd=00)
    // 1101 (ab=11, cd=01)
    // 0010 (ab=00, cd=10)
    // 0111 (ab=01, cd=11)
    // 1011 (ab=10, cd=11)
    // 1110 (ab=11, cd=10)

    // Simplified expression analysis:
    // out = (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (a & ~b & ~c & ~d) | (a & b & ~c & d) | (~a & ~b & c & ~d) | (~a & b & c & d) | (a & ~b & c & d) | (a & b & c & ~d)

    // Grouping:
    // out = ~c & ((~a & ~b & d) | (~a & b & ~d) | (a & ~b & ~d) | (a & b & d)) | c & ((~a & ~b & ~d) | (~a & b & d) | (a & ~b & d) | (a & b & ~d))
    // out = ~c & ((~a ^ b ^ d) ? ...) - wait, this is simpler:
    // out = b ^ d. Wait, let me check b ^ d:
    // b,d | b^d
    // 0,0 | 0
    // 0,1 | 1
    // 1,0 | 1
    // 1,1 | 0
    // Yes, for any (a,c), if (b,d) are (0,1) or (1,0), result is 1.
    // If (b,d) are (0,0) or (1,1), result is 0.
    // Let's check a,c effect:
    // The table shows:
    // ab=00: cd=00->0, 01->1, 11->0, 10->1.
    // Wait, row cd=00,01,11,10.
    // The table is:
    // cd=00: ab=00:0, 01:1, 11:0, 10:1
    // cd=01: ab=00:1, 01:0, 11:1, 10:0
    // cd=11: ab=00:0, 01:1, 11:0, 10:1
    // cd=10: ab=00:1, 01:0, 11:1, 10:0
    
    // Notice:
    // For a given (b,d), the output is independent of (a,c)?
    // (b,d)=(0,0) -> out=0
    // (b,d)=(0,1) -> out=1
    // (b,d)=(1,0) -> out=1
    // (b,d)=(1,1) -> out=0
    // Yes! It is exactly b ^ d.

    assign out = b ^ d;
endmodule
