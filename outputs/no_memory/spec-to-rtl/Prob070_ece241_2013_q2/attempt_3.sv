module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // K-Map for inputs:
    // Minimized SOP: 
    // Inputs (a,b,c,d):
    // 2: 0010, 7: 0111, 15: 1111
    // DC: 3:0011, 8:1000, 11:1011, 12:1100
    // SOP: (~a & ~b & c) | (b & c & d)
    // POS: (c) & (~a | b | d) & (b | ~a) ? Let's re-verify.
    
    // Using K-map:
    //      cd 00 01 11 10
    // ab 00  0  0  X  1
    //    01  0  0  1  0
    //    11  X  0  1  X
    //    10  X  0  X  0
    //
    // SOP groups: (c & ~b & ~a) [for 2] + (c & b & d) [for 7,15] -> (c & ~b & ~a) | (c & b & d)
    // Wait, 3 (0011) and 11 (1011) are DCs.
    // Group 1: 2(0010), 3(0011) -> ~a & ~b & c
    // Group 2: 7(0111), 15(1111), 3(0011), 11(1011) -> b & c & d + ~a & ~b & c? No.
    // Better SOP: (~a & ~b & c) | (c & d) ? 
    // 2: 0,0,1,0 -> 1 & 1 = 1. Yes.
    // 7: 0,1,1,1 -> 0 | 1 = 1. Yes.
    // 15:1,1,1,1 -> 0 | 1 = 1. Yes.
    // This works! SOP = (~a & ~b & c) | (c & d)
    
    // POS:
    // Group 1: 0, 1, 4, 5, 6, 8, 9, 10, 12, 13, 14 are 0.
    // POS from SOP: out = c & (~a & ~b | d)
    // POS form: c & (~a | d) & (~b | d) ?
    // Let's check:
    // 2(0010): 1 & (1|0) & (1|0) = 1. OK.
    // 7(0111): 1 & (1|1) & (0|1) = 1. OK.
    // 15(1111):1 & (0|1) & (0|1) = 1. OK.
    // 0(0000): 0 & ... = 0. OK.
    // 4(0100): 0 & ... = 0. OK.
    // Seems correct.
    
    assign out_sop = (~a & ~b & c) | (c & d);
    assign out_pos = c & (~a | d) & (~b | d);

endmodule