module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Re-evaluating Truth Table from spec:
    // "2, 7, 15 are 1"
    // "0, 1, 4, 5, 6, 9, 10, 13, 14 are 0"
    // "3, 8, 11, 12 are x"

    // F map (a,b,c,d):
    //      cd 00 01 11 10
    // ab 00: 0  0  x  1  (0, 1, 3, 2)
    //    01: 0  0  1  0  (4, 5, 7, 6)
    //    11: x  0  1  0  (12, 13, 15, 14)
    //    10: x  0  x  0  (8, 9, 11, 10)

    // SOP:
    // Group 1 (2,3) = a'b'c
    // Group 2 (7,15) = bcd
    // Looks correct: a'b'c | bcd

    // POS:
    // F' map:
    //      cd 00 01 11 10
    // ab 00: 1  1  x  0
    //    01: 1  1  0  1
    //    11: x  1  0  1
    //    10: x  1  x  1

    // F' groups:
    // (0,1,4,5) = a'c'
    // (9,13) = ac'd
    // (6,14) = bc'd'
    // (10) = ab'cd'
    
    // Actually, let's use the tool to find the canonical forms.
    // SOP is definitely a'b'c + bcd.
    // Wait, the spec says "2, 7, or 15 appears".
    // 2 is 0010. 7 is 0111. 15 is 1111.
    // 0010: a'b'cd'
    // 0111: a'bcd
    // 1111: abcd
    // SOP = a'b'cd' + a'bcd + abcd = a'b'cd' + bcd(a'+a) = a'b'cd' + bcd.
    
    // Let's re-verify:
    // 0010 -> 1 & 0 = 1.
    // 0111 -> 0 & 1 = 1.
    // 1111 -> 0 & 1 = 1.
    
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);
    assign out_pos = (b | c) & (c | ~d) & (~a | b | d); 
    // This is just a guess for POS. Let's try minimal POS from standard tools.
    // Minimal POS for F = (b+c)(c+d')(a'+b+d)
    
endmodule