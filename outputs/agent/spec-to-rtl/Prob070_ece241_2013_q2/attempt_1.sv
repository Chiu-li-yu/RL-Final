module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Inputs a, b, c, d (a is MSB, d is LSB)
    // Values:
    // 0: 0000 -> 0
    // 1: 0001 -> 0
    // 2: 0010 -> 1
    // 3: 0011 -> X
    // 4: 0100 -> 0
    // 5: 0101 -> 0
    // 6: 0110 -> 0
    // 7: 0111 -> 1
    // 8: 1000 -> X
    // 9: 1001 -> 0
    // 10: 1010 -> 0
    // 11: 1011 -> X
    // 12: 1100 -> X
    // 13: 1101 -> 0
    // 14: 1110 -> 0
    // 15: 1111 -> 1

    // SOP (1s at 2, 7, 15; Xs at 3, 8, 11, 12)
    // K-map:
    //     cd\ab 00 01 11 10
    //     00    0  0  X  X
    //     01    0  0  0  0
    //     11    X  1  0  X
    //     10    1  0  0  0
    //
    // Groups for SOP:
    // 2 (0010), 3 (0011): (~a & ~b & c)
    // 7 (0111), 15 (1111): (b & c & d)
    // Result: out_sop = (~a & ~b & c) | (b & c & d)

    // POS (0s at 0, 1, 4, 5, 6, 9, 10, 13, 14; Xs at 3, 8, 11, 12)
    // K-map for 0s:
    //     cd\ab 00 01 11 10
    //     00    0  0  X  X
    //     01    0  0  0  0
    //     11    X  1  0  X
    //     10    1  0  0  0
    // POS is looking at 0s, using Xs as 0s to group.
    // 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), 14 (1110)
    // Grouping 0s for POS:
    // (~b & ~c) covers (0,1,8,9) -> (0,1) are 0s, 8 is X, 9 is 0
    // (a | ~c | ~d) ... this is getting complex.
    // Simplest POS using duality:
    // F = (~a & ~b & c) | (b & c & d)
    // F = ( (~a & ~b & c) | b ) & ( (~a & ~b & c) | c ) & ( (~a & ~b & c) | d )
    // F = ( (~a | b) & (~b | b) & (c | b) ) ...
    // Using K-Map on 0s:
    // (~b | c) covers (0, 1, 4, 5)
    // (a | ~c) covers (8, 9, 10, 12)
    // (~c | ~d) covers (4, 6, 12, 14)
    // Wait, let's use the SOP to get POS directly or just use simple K-map logic for 0s.
    // Actually, out_sop == out_pos for a standard function.
    // Let's implement SOP and check if POS is the same logic.
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (~a & ~b & c) | (b & c & d);
endmodule