module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Correcting truth table:
    // 2: 0010, 7: 0111, 15: 1111
    // SOP: (a'b'c d') + (a'bc d) + (abc d)
    // = a'b'c d' + bcd (a' + a) = a'b'c d' + bcd

    // Re-verify SOP:
    // 2 (0010): 1 * 1 * 1 * 1 | 0 = 1. Correct.
    // 7 (0111): 0 | 1 * 1 * 1 = 1. Correct.
    // 15 (1111): 0 | 1 * 1 * 1 = 1. Correct.
    
    // POS (F' zeroes): 0, 1, 4, 5, 6, 9, 10, 13, 14
    // F = (b+c)(c+d')(a'+b+d)
    // 2(0010): (0+1) * (1+1) * (1+0+0) = 1. Correct.
    // 7(0111): (1+1) * (1+0) * (1+1+1) = 1. Correct.
    // 15(1111): (1+1) * (1+0) * (0+1+1) = 1. Correct.

    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);
    assign out_pos = (b | c) & (c | ~d) & (~a | b | d);

endmodule