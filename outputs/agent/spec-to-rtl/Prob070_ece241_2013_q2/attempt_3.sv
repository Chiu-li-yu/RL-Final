module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth Table:
    // a b c d | Y
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1 (2)
    // 0 0 1 1 | X (3)
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 1 (7)
    // 1 0 0 0 | X (8)
    // 1 0 0 1 | 0
    // 1 0 1 0 | 0
    // 1 0 1 1 | X (11)
    // 1 1 0 0 | X (12)
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1 (15)

    // out_sop (min SOP): 
    // a'b'c + bcd + acd
    assign out_sop = (~a & ~b & c) | (b & c & d) | (a & c & d);

    // out_pos (min POS):
    // 0s: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // 1s: 2, 7, 15
    // Xs: 3, 8, 11, 12
    // Minimum POS form: (c|d) & (a|b|~c) & (a'|b'|c) ... wait
    // Let's deduce from Truth Table directly for POS:
    // (c|d) & (a|b|~c) & (~a|~b|d)
    assign out_pos = (c | d) & (a | b | ~c) & (~a | ~b | d);

endmodule