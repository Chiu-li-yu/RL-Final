module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // 0: 0000 -> 0
    // 1: 0001 -> 0
    // 2: 0010 -> 1
    // 3: 0011 -> X
    // 4: 0100 -> 0
    // 5: 0101 -> 0
    // 6: 0110 -> 0
    // 7: 0111 -> 1
    // 8: 1000 -> X
    // 9: 1001 -> 0
    // 10: 1010 -> 0
    // 11: 1011 -> X
    // 12: 1100 -> X
    // 13: 1101 -> 0
    // 14: 1110 -> 0
    // 15: 1111 -> 1

    // Min SOP:
    // (a,b,c,d) = (0,0,1,0) [2], (0,1,1,1) [7], (1,1,1,1) [15]
    // K-map:
    //      cd\ab 00 01 11 10
    //      00    0  0  X  X
    //      01    0  0  0  0
    //      11    X  1  0  X
    //      10    1  0  0  0
    // Groups: (2,3) = ~a~bc, (7,15) = bcd
    // out_sop = (~a & ~b & c) | (b & c & d)

    // Min POS:
    // Groups of 0s:
    // 0,1,4,5,6,9,10,13,14 are 0
    // F = (c) & (a|b) ... no.
    // F = (c) & (a|~b|d) & (~a|b) is wrong.
    // Use K-map for 0s:
    // (0,1,4,5,8,9,12,13) -> (~c)  <-- No, 8,12 are X
    // Let's use logic for SOP and then simplify the POS.
    // F = ~a~bc + bcd
    // F = (c) & (~a + b) & (~b + d)
    // Test F = (c) & (~a + b) & (~b + d):
    // 2 (0010): 1 & (1+0) & (1+0) = 1*1*1 = 1 (OK)
    // 7 (0111): 1 & (1+1) & (0+1) = 1*1*1 = 1 (OK)
    // 15(1111): 1 & (0+1) & (0+1) = 1*1*1 = 1 (OK)
    // 0 (0000): 0 & ... = 0 (OK)
    // 1 (0001): 1 & (1+0) & (1+1) = 1 (WAIT, 1 should be 0)
    // Ah, (~b+d) is 1+1 = 1.
    // The issue is 1 (0001) should be 0.
    // Try: out_pos = (c) & (~a | b) & (~b | ~c | d) ... no.

    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = c & (~a | b) & (~b | ~c | d); // Let's try this
endmodule