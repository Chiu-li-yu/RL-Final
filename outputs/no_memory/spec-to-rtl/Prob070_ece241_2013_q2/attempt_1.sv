module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // K-Map Analysis:
    // Inputs (a,b,c,d)
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

    // SOP (Sum of Products):
    // Grouping 1s:
    // Minterm 2: a'b'cd'
    // Minterm 7: a'bcd
    // Minterm 15: abcd
    // Using Don't Cares (3, 8, 11, 12):
    // Group (2, 3): a'b'c
    // Group (7, 15): bcd
    // SOP = a'b'c + bcd

    // POS (Product of Sums):
    // Simplified SOP for logic 1 is f = a'b'c + bcd
    // Simplified POS for logic 0 (looking at the complement or dual):
    // POS = (c+b') * (c+d) ? Let's derive.
    // The dual of f_sop is f_pos = (a'+c) * (b+c) * (b'+d) ...?
    // Let's re-verify:
    // f = c(a'b' + bd) = c(a'+b)(b'+b)(b'+d) = c(a'+b)(b'+d) = (c+0)(a'+b)(b'+d)
    // Actually, f = (c) AND (a'+b) AND (b'+d).
    // Let's check this POS:
    // f = (c) & (~a | b) & (~b | d)
    // 2 (0010): (1) & (1|0) & (1|0) = 1*1*1 = 1 (Correct)
    // 7 (0111): (1) & (1|1) & (0|1) = 1*1*1 = 1 (Correct)
    // 15(1111): (1) & (0|1) & (0|1) = 1*1*1 = 1 (Correct)
    // POS seems to be (c) & (~a | b) & (~b | d)

    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (c) & (~a | b) & (~b | d);

endmodule