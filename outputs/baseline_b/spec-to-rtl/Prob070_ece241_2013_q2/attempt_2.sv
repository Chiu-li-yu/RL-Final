module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Inputs (a,b,c,d) represent the number as a 4-bit integer.
    // 0: 0000, 1: 0001, 2: 0010, 3: 0011, 4: 0100, 5: 0101, 6: 0110, 7: 0111,
    // 8: 1000, 9: 1001, 10: 1010, 11: 1011, 12: 1100, 13: 1101, 14: 1110, 15: 1111
    // Logic-1 (minterms): 2, 7, 15
    // Logic-0 (minterms): 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Don't care: 3, 8, 11, 12

    // K-map (a,b,c,d):
    //       cd 00 01 11 10
    //    ab
    //    00    0  0  ?  1   (0, 1, 3, 2)
    //    01    0  0  1  0   (4, 5, 7, 6)
    //    11    ?  0  1  0   (12, 13, 15, 14)
    //    10    ?  0  ?  0   (8, 9, 11, 10)

    // SOP minimization (1s): 
    // Minterms: 2 (0010), 7 (0111), 15 (1111)
    // Don't cares: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    // Grouping:
    // 1. (2, 3) = a'b'c
    // 2. (7, 15) = bc'd + bcd ... no. 
    //    7: 0111, 15: 1111 -> c d
    //    Wait, 7(0111), 15(1111). 
    //    Let's recheck K-map:
    //    2: 0010, 7: 0111, 15: 1111
    //    Groups:
    //    (2, 3) : a'b'c
    //    (7, 15): bc d? no, 0111, 1111 -> b c d (0111, 1111). Correct.
    //    Check 15 again: 1111. 
    //    Yes, (7, 15) = bcd. 
    //    out_sop = a'b'c + bcd

    // POS minimization (0s):
    // Minterms for 0: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Don't cares: 3, 8, 11, 12
    // K-map for 0s:
    //       cd 00 01 11 10
    //    ab
    //    00    1  1  ?  0
    //    01    1  1  0  1
    //    11    ?  1  0  1
    //    10    ?  1  ?  1
    
    // Grouping for 0s:
    // 1. (0, 1, 4, 5) = a'c'
    // 2. (6, 14) = bcd'? no, (6: 0110, 14: 1110) = bc'd? no, (6: 0110, 14: 1110) = bc d'? Wait.
    //    0110, 1110 -> 110. So b c d'. Correct.
    // 3. (9, 13) = acd'?
    // Let's use boolean simplification for POS:
    // F = (a'b'c + bcd)
    // F' = (a + b + c')(b' + c' + d') = (a+b+c')(b'+c'+d')
    // Wait, let's use the K-map for 0s directly.
    // 0s at: 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
    // Simplification for 0:
    // (a+c') group 1: (0, 1, 4, 5) -> 0000, 0001, 0100, 0101. a'c'. Correct.
    // (a'+b+d) group 2: ... this is tricky. 
    // Let's stick with: out_sop = (~a & ~b & c) | (b & c & d)
    // For out_pos, let's use de Morgan on the SOP:
    // F = a'b'c + bcd
    // F = c(a'b' + bd) = c(a'+b)(b'+d) = (c)(a'+b)(b'+d)
    // This is a product of sums.
    // So out_pos = c & (~a | b) & (~b | d)
    
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = c & (~a | b) & (~b | d);

endmodule
