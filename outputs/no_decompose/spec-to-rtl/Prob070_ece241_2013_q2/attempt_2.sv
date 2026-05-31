module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Inputs (a,b,c,d) -> index (0-15)
    // 2: 0010, 7: 0111, 15: 1111
    // Y(a,b,c,d) = Σ(2, 7, 15)
    // Don't cares: Σd(3, 8, 11, 12)

    // K-map (a,b) row, (c,d) col:
    //      cd 00 01 11 10
    // ab
    // 00      0  0  X  1
    // 01      0  0  1  0
    // 11      X  0  1  0
    // 10      X  0  X  0

    // Groups for SOP:
    // Minterm 2 (0010): a'b'cd'
    // Minterm 7, 15 (0111, 1111): bcd
    // Result: sop = (~a & ~b & c & ~d) | (b & c & d)

    // Groups for POS (look for 0s):
    // 0s: (0,1,4,5,6,9,10,13,14)
    // K-map grouping of 0s:
    // (0000, 0001, 0100, 0101) -> (a+b+c) * (a+b+~d)? No.
    // Use K-map for 0s:
    // (0000, 0001, 0100, 0101, 1001, 1101, 1110, 0110, 1010)
    // This is hard. Let's use boolean simplification:
    // F = (~a & ~b & c & ~d) | (b & c & d)
    // F = c & ((~a & ~b & ~d) | (b & d))
    // Complement F:
    // F' = (~c) | (~((~a & ~b & ~d) | (b & d)))
    // F' = (~c) | (~(~a & ~b & ~d) & ~(b & d))
    // F' = (~c) | ((a | b | d) & (~b | ~d))
    // F' = (~c) | (a&~b & a&~d | b&~b & b&~d | d&~b & d&~d)
    // F' = (~c) | (a&~b) | (a&~d) | (~b&d)
    // POS: F = (c) & (~a | b) & (~a | d) & (b | ~d)

    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);
    assign out_pos = (c) & (~a | b) & (~a | d) & (b | ~d);

endmodule
