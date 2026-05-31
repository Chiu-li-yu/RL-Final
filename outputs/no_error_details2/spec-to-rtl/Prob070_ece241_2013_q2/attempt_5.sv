module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Let's re-verify:
    // 2 (0010) - Correct (a=0, b=0, c=1, d=0)
    // 7 (0111) - Correct (a=0, b=1, c=1, d=1)
    // 15 (1111) - Correct (a=1, b=1, c=1, d=1)
    
    // Maybe SOP is wrong?
    // 1: a'b'c
    // 2: bcd
    // 3: a'b'c + bcd
    // 7: 0111. a'b'c = 1*1*1 = 1? No. a=0, b=1, c=1. a'=1, b'=0.
    // 0111: a=0, b=1, c=1. a'=1, b'=0. So a'b'c = 0. bcd = 1*1*1 = 1.
    // So 0 | 1 = 1. Correct.
    // 2 (0010): a=0, b=0, c=1, d=0. a'b'c = 1*1*1 = 1. bcd = 0.
    // So 1 | 0 = 1. Correct.

    // Let me try to simplify the expression without assuming a'b'c and bcd are the only terms.
    // F = Σm(2, 7, 15) + Σd(3, 8, 11, 12)
    // K-map:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | 1  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    //
    // Groups:
    // Group 1: (2, 3) = a'b'c
    // Group 2: (7, 15) = bcd
    // The expression a'b'c + bcd should be correct.
    
    // Wait, could it be a different representation for SOP/POS?
    // Maybe out_sop = a'b'c + bcd is just not the *minimal* SOP?
    // Is there a better one? 
    // Let's check 1111 (15): a'b'c + bcd = 0 + 1 = 1.
    // Let's check 7 (0111): a'b'c + bcd = 0 + 1 = 1.
    // Let's check 2 (0010): a'b'c + bcd = 1 + 0 = 1.
    // Seems minimal.

    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (a | c) & (~b | ~c | d) & (~a | ~c | d);
endmodule