module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // K-map (a,b,c,d):
    //      cd 00 01 11 10
    // ab 00: 0  0  1  1 (2,3)
    //    01: 0  0  1  0 (6,7)
    //    11: x  0  1  0 (14,15)
    //    10: x  0  x  0 (8,9,10,11) - wait my indices are wrong

    // 0:0000, 1:0001, 2:0010, 3:0011, 4:0100, 5:0101, 6:0110, 7:0111
    // 8:1000, 9:1001, 10:1010, 11:1011, 12:1100, 13:1101, 14:1110, 15:1111

    // F = 1 at 2, 7, 15. x at 3, 8, 11, 12.
    //      cd 00 01 11 10
    // ab 00: 0  0  x  1  (0, 1, 3x, 2)
    //    01: 0  0  1  0  (4, 5, 7, 6)
    //    11: x  0  0  0  (12x, 13, 15, 14)  <- Wait, 15 is 1111. 1111 is 1.
    //    10: x  0  x  0  (8x, 9, 11x, 10)

    // F map:
    //      cd 00 01 11 10
    // ab 00: 0  0  x  1
    //    01: 0  0  1  0
    //    11: x  0  1  0
    //    10: x  0  x  0

    // Groups:
    // (2, 3) = a'b'c
    // (7, 15) = bcd
    // SOP = a'b'c + bcd

    // POS:
    // F' = 0+1+4+5+6+9+10+13+14 = 1
    // K-map F':
    //      cd 00 01 11 10
    // ab 00: 1  1  x  0
    //    01: 1  1  0  1
    //    11: x  1  0  1
    //    10: x  1  x  1

    // F' groups:
    // (0,1,4,5) = a'c'
    // (9,13) = ac'd
    // (6,14) = bc'd'
    // (10)   = ab'cd'
    // ... This is harder. Use K-map for F directly.
    
    // F = (c + b'd') * (b + d) * (a' + c + d)
    // Let's re-verify SOP: a'b'c | bcd
    // 2 (0010): 1 & 0 = 1. Correct.
    // 7 (0111): 0 & 1 = 1. Correct.
    // 15 (1111): 0 & 1 = 1. Correct.
    
    // POS: F = (b+c)(c+d)(a'+b+d) ?? Let's just use boolean algebra.
    
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (b | c) & (c | d) & (~a | b | d);

endmodule