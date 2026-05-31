module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Inputs a, b, c, d
    // Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    // Binary:  0000, 0001, 0010, 0011, 0100, 0101, 0110, 0111, 1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111
    // Target (1): 2, 7, 15
    // Target (0): 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Don't Care (X): 3, 8, 11, 12

    // SOP (Sum of Products)
    // K-map:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 0  | 0  | X  | 0
    //      01      | 0  | 0  | 0  | 0
    //      11      | 1  | 1  | 1  | X
    //      10      | 1  | 0  | X  | 0
    // Simplified SOP: b*c + a*c*d (or similar)
    // Actually, check 2 (0010), 7 (0111), 15 (1111)
    // (0010) = ~a~bc~d
    // (0111) = ~abc d
    // (1111) = abcd
    // Using K-map:
    // SOP: (~a*b*~d) + (c*d) ? Let's verify.
    // 2 (0010): 1*0 + 1*0 = 0 (Fail)
    // Re-eval K-map:
    // ab \ cd | 00 | 01 | 11 | 10
    // 00      | 0  | 0  | 0  | 1  (2 is 0010)
    // 01      | 0  | 0  | 1  | 0  (7 is 0111)
    // 11      | X  | X  | 1  | X  (15 is 1111)
    // 10      | 0  | 0  | X  | 0
    
    // SOP: out_sop = (~a & ~b & c & ~d) | (b & c & d) | (a & b & c & d)
    // Simplification:
    // SOP = (~a & ~b & c & ~d) | (c & d)
    
    // POS (Product of Sums)
    // Complementary to SOP in terms of 0s.
    // Logic 1 when: 2, 7, 15
    // Logic 0 when: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Don't Care: 3, 8, 11, 12
    // Minimal POS can be derived from K-map of 0s.

    assign out_sop = (~a & ~b & c & ~d) | (c & d);
    assign out_pos = (c | ~d) & (~b | c) & (~a | ~b | d);

endmodule
