module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Re-evaluating K-map for SOP:
    // Numbers: 2 (0010), 7 (0111), 15 (1111)
    // Don't Care: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    //
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | X  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    
    // Grouping for SOP:
    // (0010, 0011, 1011, 1010 - wait, 1010 is 10)
    // 0010 (2)
    // 0011 (3)
    // 0111 (7)
    // 1111 (15)
    // 1011 (11)
    // 1100 (12)
    // 1000 (8)
    
    // Actually using minterms: 2, 7, 15
    // 2: ~a~bc~d
    // 7: ~abc d
    // 15: abcd
    // K-map:
    //      ab\cd | 00 | 01 | 11 | 10
    //      00    | 0  | 0  | X  | 1
    //      01    | 0  | 0  | 1  | 0
    //      11    | X  | 0  | 1  | 0
    //      10    | X  | 0  | X  | 0
    
    // Simplified SOP: (~a & ~b & c) | (c & d)
    // Check 2: 1 | 0 = 1 (OK)
    // Check 7: 0 | 1 = 1 (OK)
    // Check 15: 0 | 1 = 1 (OK)
    
    // Simplified POS: c & (~b | d) & (~a | d)
    // Check 2: 1 & (1|0) & (1|0) = 1 (OK)
    // Check 7: 1 & (0|1) & (0|1) = 1 (OK)
    // Check 15: 1 & (0|1) & (0|1) = 1 (OK)

    assign out_sop = (~a & ~b & c) | (c & d);
    assign out_pos = c & (~b | d) & (~a | d);

endmodule
