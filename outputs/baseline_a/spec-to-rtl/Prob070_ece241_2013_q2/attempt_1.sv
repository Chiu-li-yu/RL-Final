module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Inputs: a, b, c, d (a is MSB, d is LSB)
    // Numbers: 0(0000), 1(0001), 2(0010), 3(0011), 4(0100), 5(0101), 6(0110), 7(0111)
    //          8(1000), 9(1001), 10(1010), 11(1011), 12(1100), 13(1101), 14(1110), 15(1111)

    // Truth Table:
    // a b c d | num | out
    // 0 0 0 0 | 0   | 0
    // 0 0 0 1 | 1   | 0
    // 0 0 1 0 | 2   | 1
    // 0 0 1 1 | 3   | X (don't care)
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

    // K-map:
    //      cd
    // ab   00 01 11 10
    // 00 | 0  0  X  1  | 2, 3
    // 01 | 0  0  1  0  | 6, 7
    // 11 | X  0  1  0  | 14, 15
    // 10 | X  0  X  0  | 10, 11 (Wait: 8, 9, 10, 11) -> 10, 11. Correction: 8,9,10,11
    
    // Let's re-map:
    //     cd
    // ab  00 01 11 10
    // 00| 0  0  X  1
    // 01| 0  0  1  0
    // 11| X  0  1  0
    // 10| X  0  X  0

    // SOP: 
    // Terms are 2 (0010), 7 (0111), 15 (1111)
    // Don't cares: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    
    // K-Map visualization:
    //        c'd' c'd cd cd'
    // a'b' | 0    0   X  1   (0, 1, 3, 2)
    // a'b  | 0    0   1  0   (4, 5, 7, 6)
    // ab   | X    0   1  0   (12, 13, 15, 14)
    // ab'  | X    0   X  0   (8, 9, 11, 10)

    // SOP groups:
    // 1. (001x) -> a'b'c
    // 2. (x111) -> bcd
    // But check groups:
    // 2 (0010) and 3 (0011): a'b'c
    // 7 (0111) and 15 (1111): bcd
    // SOP = a'b'c + bcd

    // POS:
    // Minterms that are 0: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Don't cares: 3, 8, 11, 12
    // Look at 0s on K-map:
    // POS = (a+b+c')(a'+c+d)(b'+c+d) ??
    // Let's re-verify:
    // SOP = a'b'c + bcd
    // If SOP is minimized, SOP = a'b'c + bcd.
    // Let's check POS.
    // 0: (a+b+c')(a+b+c+d)(...) 
    // Simplified POS:
    // POS = (b+c)(a'+c)(c+d)? No.
    // Try: (c)(a'+b)(b'+d) ... 
    // Wait, let's use the K-map for 0s.
    // 0s at: 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
    // Don't cares: 0011, 1000, 1011, 1100
    // Groups of 0s:
    // 1. (0,1,4,5): a'b' + a'b = a' (Wait: 0000, 0001, 0100, 0101 -> a'c'd' + a'c'd + a'bc'd' + a'bc'd = a'c') -> a'c'
    // 2. (0,4,8,12) -> b'c'd' + bc'd' + a... No.
    
    // Let's re-evaluate:
    // SOP = a'b'c + bcd
    // Since it's a small K-map, POS can be derived from the complement of the SOP?
    // Not directly, need to map 0s.
    // Let's write the logic clearly.
    
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (c) & (a | ~b | d) & (~a | b | ~c | ~d); // This might be wrong.
    
    // Let's use simple minterm sum for now to get it right.
    // out_pos = (a+c) & (b+c) & (a'+c'+d')? 
    // Actually, min POS: (c) & (a'+b) & (b'+d)? 
    // Let's test:
    // 2 (0010): (1) & (1) & (1) = 1 (Correct)
    // 7 (0111): (1) & (1) & (1) = 1 (Correct)
    // 15(1111): (1) & (1) & (1) = 1 (Correct)
    // 0 (0000): (0) & (1) & (1) = 0 (Correct)
    // 1 (0001): (0) & (1) & (1) = 0 (Correct)
    // 4 (0100): (0) & (0) & (1) = 0 (Correct)
    // 5 (0101): (0) & (0) & (0) = 0 (Correct)
    // 6 (0110): (1) & (0) & (1) = 0 (Correct)
    
    // Wait, (c) & (a'+b) & (b'+d) seems to cover 2, 7, 15 and 0s are 0.
    // Let's re-verify 6: 0110. (c=1, a'+b=1, b'+d=0) -> 0. Correct.
    // Let's re-verify 9: 1001. (c=0, a'+b=0, b'+d=1) -> 0. Correct.
    // 10: 1010. (c=1, a'+b=0, b'+d=1) -> 0. Correct.
    
    assign out_pos = (c) & (~a | b) & (~b | d);

endmodule
