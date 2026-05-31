module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Truth Table:
    // a b c d | num | out
    // 0 0 0 0 | 0   | 0
    // 0 0 0 1 | 1   | 0
    // 0 0 1 0 | 2   | 1
    // 0 0 1 1 | 3   | X
    // 0 1 0 0 | 4   | 0
    // 0 1 0 1 | 5   | 0
    // 0 1 1 0 | 6   | 0
    // 0 1 1 1 | 7   | 1
    // 1 0 0 0 | 8   | X
    // 1 0 0 1 | 9   | 0
    // 1 0 1 0 | 10  | 0
    // 1 0 1 1 | 11  | X
    // 1 1 0 0 | 12  | X
    // 1 1 0 1 | 13  | 0
    // 1 1 1 0 | 14  | 0
    // 1 1 1 1 | 15  | 1

    // SOP K-map (1s and Xs):
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | 1  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    
    // Grouping:
    // 1. (0010, 0011, 1010, 1011) -> ~b*c*~a + ~b*c*a = ~b*c (Wait, 0011 is 3, 1011 is 11)
    // Actually, looking at K-map again:
    // ab \ cd | 00 | 01 | 11 | 10
    // 00      | 0  | 0  | X  | 1
    // 01      | 0  | 0  | 1  | 0
    // 11      | X  | 0  | 1  | 0
    // 10      | X  | 0  | X  | 0
    
    // Grouping 1s (2, 7, 15):
    // - (0010) and (0011) -> ~a*~b*c
    // - (0111) and (1111) -> b*c*d
    // - (0011) and (1111) and (1011) and (0111)? No.
    
    // Minimal SOP: (~a & ~b & c) | (b & c & d)
    // Check:
    // 2 (0010): 1 & 0 = 1 (OK)
    // 7 (0111): 0 | 1 = 1 (OK)
    // 15 (1111): 0 | 1 = 1 (OK)
    
    // POS (Product of Sums):
    // K-map of 0s:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | X  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    
    // Correct POS (from SOP complement):
    // out_sop = (~a & ~b & c) | (b & c & d)
    // out_sop = c & (~a & ~b | b & d)
    // out_pos = c & (~a | b) & (~b | ~a) ? No.

    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = c & (~a | b) & (~b | d);

endmodule
