module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Boolean function F = sum(2, 7, 15) with X(3, 8, 11, 12)
    // F(a,b,c,d) = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)
    // Don't cares:
    // 3: ~a & ~b & c & d
    // 8: a & ~b & ~c & ~d
    // 11: a & ~b & c & d
    // 12: a & b & ~c & ~d

    // SOP (Minimal):
    // ~a & c (covers 2, 3)
    // c & d & b (covers 7, 15)
    // c & d & a (covers 11, 15)
    // SOP = (~a & c) | (b & c & d) | (a & c & d) = ~a & c | c & d & (a | b)
    assign out_sop = (~a & c) | (c & d & (a | b));

    // POS (Minimal):
    // F = (c) * (a' + d) * (a + b + c')? Let's check.
    // Truth table:
    // 0: 0, 1: 0, 2: 1, 3: X, 4: 0, 5: 0, 6: 0, 7: 1, 8: X, 9: 0, 10: 0, 11: X, 12: X, 13: 0, 14: 0, 15: 1
    // (c) * (a' + d) * (a + b + c')
    // 0000: 0 * 1 * 1 = 0 (OK)
    // 0010: 1 * 1 * 1 = 1 (OK)
    // 0111: 1 * 1 * 1 = 1 (OK)
    // 1111: 1 * 1 * 1 = 1 (OK)
    // 1001: 0 * 0 * 1 = 0 (OK)
    // 1010: 1 * 0 * 1 = 0 (OK)
    assign out_pos = c & (~a | d) & (a | b | ~c);

endmodule
