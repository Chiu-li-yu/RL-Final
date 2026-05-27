module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth table:
    // a b c d | Output
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

    // K-map:
    //      cd
    // ab   00 01 11 10
    // 00   0  0  X  1
    // 01   0  0  1  0
    // 11   X  0  1  0
    // 10   X  0  X  0

    // Redoing K-Map for SOP (1s):
    // 2 (0010)
    // 7 (0111)
    // 15 (1111)
    // Xs: 3(0011), 8(1000), 11(1011), 12(1100)
    
    // Group 1: 0010, 0011 (2,3) -> !a!bc
    // Group 2: 0111, 1111 (7,15) -> bc
    // Wait, 15 is 1111. 7 is 0111. So bc is not enough. Group 2 is bcd?
    // Let's re-verify:
    // 7 is 0111, 15 is 1111. Group 2 is bcd.
    // SOP = (!a & !b & c) | (b & c & d)
    
    // Redoing K-Map for POS (0s):
    // 0(0000), 1(0001), 4(0100), 5(0101), 6(0110), 9(1001), 10(1010), 13(1101), 14(1110)
    // Minimizing 0s:
    // 0: 0000, 1: 0001, 4: 0100, 5: 0101, 6: 0110, 9: 1001, 10: 1010, 13: 1101, 14: 1110
    // This is hard to do in my head. Let's use the standard canonical POS.
    // The POS expression should be: (a+c) * (b+c) * ... no.
    // Let's try:
    // SOP: (~a & ~b & c) | (b & c & d)
    // POS: (c) & (~a | b) & (~b | d) ... wait.
    
    // Let's try this:
    // SOP = (~a & ~b & c) | (b & c & d)
    // POS = (c) & (~a | d) & (b | ~a) ... this is not correct.
    
    // Let's use the minterm expansion.
    // Output 1 at: m2, m7, m15.
    // Output 0 at: m0, m1, m4, m5, m6, m9, m10, m13, m14.
    // POS = Product(Maxterms where output is 0)
    // M0(a+b+c+d), M1(a+b+c+!d), M4(a+!b+c+d), M5(a+!b+c+!d), M6(a+!b+!c+d), M9(!a+b+c+!d), M10(!a+b+!c+d), M13(!a+!b+c+!d), M14(!a+!b+!c+d)
    
    // Simplified POS: (a+c) & (!b+c) & (b+!c+!d)
    
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (a | c) & (~b | c) & (b | ~c | ~d);

endmodule
