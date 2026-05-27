module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Inputs a, b, c, d correspond to 8, 4, 2, 1 weights
    // Truth Table:
    // 0000 (0): 0
    // 0001 (1): 0
    // 0010 (2): 1
    // 0011 (3): X
    // 0100 (4): 0
    // 0101 (5): 0
    // 0110 (6): 0
    // 0111 (7): 1
    // 1000 (8): X
    // 1001 (9): 0
    // 1010 (10): 0
    // 1011 (11): X
    // 1100 (12): X
    // 1101 (13): 0
    // 1110 (14): 0
    // 1111 (15): 1

    // Mapping:
    // f(a,b,c,d) = Sum(m(2, 7, 15)) + Sum(d(3, 8, 11, 12))
    
    // K-map:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------+----+----+----+----
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | 1  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    
    // Simplification for SOP:
    // Groups:
    // m(2,3) -> b'cd' + b'c'd = b'c(d'+d) = b'c. Actually m(2,3) is b'cd'.
    // Wait, let's re-verify:
    // m2=0010, m3=0011, m7=0111, m11=1011, m15=1111
    
    // Grouping 1s:
    // 2 (0010) and 3 (0011) -> b'cd' + b'cd = b'c
    // 7 (0111) and 15 (1111) -> bcd + abd = (b+a)cd
    // Actually, K-Map:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | 1  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    //
    // Groups of 1s + Xs:
    // (2,3): 001x -> b'c
    // (7,15): x111 -> bcd
    // (3,11): x011 -> c d (wait, 3 is 0011, 11 is 1011, 15 is 1111, 7 is 0111)
    
    // Let's use Sum of Products directly from K-Map:
    // SOP: out_sop = b'c + cd (This covers 2, 3, 7, 11, 15)
    // POS: out_pos = c(b'+d) = b'c + cd. Same expression.
    
    // Check:
    // 2 (0010): b'c = 1*1 = 1. Correct.
    // 7 (0111): b'c (0) + cd (1) = 1. Correct.
    // 15 (1111): b'c (0) + cd (1) = 1. Correct.
    // 1 (0001): 1*0 + 0*1 = 0. Correct.
    // 0 (0000): 0. Correct.

    assign out_sop = (~b & c) | (c & d);
    assign out_pos = (~b & c) | (c & d);

endmodule
