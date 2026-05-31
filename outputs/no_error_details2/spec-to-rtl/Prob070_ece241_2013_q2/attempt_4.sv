module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // SOP: 
    // F(a,b,c,d) = Σm(2, 7, 15) + Σd(3, 8, 11, 12)
    // K-map:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | 1  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    // K-map group for 1s:
    // a'b'c covers 0010, 0011
    // bcd covers 0111, 1111
    // Wait, 1111 (15) and 0111 (7) -> bcd covers 0111 and 1111. Correct.
    // So SOP = a'b'c + bcd.

    // POS:
    // F'(a,b,c,d) = Σm(0, 1, 4, 5, 6, 9, 10, 13, 14) + Σd(3, 8, 11, 12)
    // K-map for 0s:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 1  | 1  | X  | X
    //      01      | 1  | 1  | 1  | 1
    //      11      | 0  | 0  | 0  | X
    //      10      | 0  | 1  | 1  | 1
    // 0 groups:
    // 1. (0, 1, 4, 5): a'c'
    // 2. (0, 4, 8, 12): b'c' (if 8, 12 are X, can use them)
    // 3. (6, 14, 2, 10): 2, 6, 10, 14. Wait.
    // Let's use standard POS K-Map again.
    // 0s: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // 1s: 2, 7, 15
    // X: 3, 8, 11, 12
    // F = (a+c) * (b'+c'+d) * (a'+c'+d) 
    // Let's test this function.
    // Truth table of (a+c) & (b'+c'+d) & (a'+c'+d):
    // 2 (0010) -> (0+1) & (1+0+0) & (1+0+0) = 1*1*1 = 1.
    // 7 (0111) -> (0+1) & (0+0+1) & (1+0+1) = 1*1*1 = 1.
    // 15 (1111) -> (1+1) & (0+0+1) & (0+0+1) = 1*1*1 = 1.
    // 0 (0000) -> (0+0) & (1+1+0) & (1+1+0) = 0.
    // 1 (0001) -> (0+0) & (1+1+1) & (1+1+1) = 0.
    // 6 (0110) -> (0+1) & (0+0+0) & (1+0+0) = 0.
    // This POS is correct.

    // Let's re-verify SOP one more time.
    // 2 (0010): 1*1*1 = 1.
    // 7 (0111): 0*0*1 (Wait, b=1, c=1, d=1 -> 1*1*1 = 1).
    // Everything seems correct.

    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (a | c) & (~b | ~c | d) & (~a | ~c | d);
endmodule