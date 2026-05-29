
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum of Products (SOP)
    // 1s: 2, 7, 15
    // Xs: 3, 8, 11, 12
    // K-map analysis:
    // - Minterms (7, 15, 11, 3) form a group: c & d
    // - Minterms (2, 3) form a group: ~a & ~b & c
    assign out_sop = (c && d) || (!a && !b && c);

    // Product of Sums (POS)
    // 0s: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Xs: 3, 8, 11, 12
    // K-map analysis:
    // - Group covering 0s at 0, 1, 4, 5, 8, 9, 12, 13: c = 0 -> Term: (c)
    // - Remaining 0s: 6, 10, 14
    // - Group covering 6, 14: ~b | ~c | d (but since c is already a term, this becomes ~b | d)
    // - Group covering 10, 14: ~a | ~c | d (but since c is already a term, this becomes ~a | d)
    assign out_pos = c && (!a || d) && (!b || d);

endmodule
