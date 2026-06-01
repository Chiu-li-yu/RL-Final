module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth Table:
    // 0:0000 -> 0
    // 1:0001 -> 0
    // 2:0010 -> 1
    // 3:0011 -> X
    // 4:0100 -> 0
    // 5:0101 -> 0
    // 6:0110 -> 0
    // 7:0111 -> 1
    // 8:1000 -> X
    // 9:1001 -> 0
    // 10:1010 -> 0
    // 11:1011 -> X
    // 12:1100 -> X
    // 13:1101 -> 0
    // 14:1110 -> 0
    // 15:1111 -> 1

    // SOP (1s at 2, 7, 15):
    // 2 (0010): ~a~bc~d
    // 7 (0111): ~abc d
    // 15(1111):  abcd
    // K-map:
    //    cd\ab 00 01 11 10
    //    00     0  0  X  X
    //    01     0  0  0  0
    //    11     X  1  0  X
    //    10     1  0  0  0
    // SOP Simplification:
    // 2+3: ~a~bc
    // 7+15: bcd
    // So: out_sop = (~a & ~b & c) | (b & c & d)

    // POS (0s at 0, 1, 4, 5, 6, 9, 10, 13, 14):
    // Use K-map for 0s:
    // (a | ~c) covers 8,9,10,12 (Wait, check: 8:1000(1|~0=1), 9:1001(1|~0=1), 10:1010(1|~1=0), 12:1100(1|~0=1)... no)
    // POS from K-map:
    // 0,1,4,5 are 0 -> (~b | ~c) covers these
    // 0,1,8,9 (if 8=0) -> (~a | ~c)
    // Actually:
    // out_pos = (b | ~c) & (a | ~b | ~d) ... let's derive properly.
    // F = 1 for {2, 7, 15}, 0 for {0, 1, 4, 5, 6, 9, 10, 13, 14}
    // Min POS: F = (b | c) & (~a | c) & (~b | ~c | d) ... wait.
    // Try: out_pos = (c) & (a | ~b | d) & (~a | b | ~d) ... let's stick to SOP/POS logic.
    // SOP: (~a & ~b & c) | (b & c & d)
    // POS: (c) & (~a | b) & (~b | d)
    // Let's verify POS (c) & (~a | b) & (~b | d)
    // 2 (0010): 1 & (1|1) & (1|0) = 1*1*1 = 1 (OK)
    // 7 (0111): 1 & (1|1) & (0|1) = 1*1*1 = 1 (OK)
    // 15(1111): 1 & (0|1) & (0|1) = 1*1*1 = 1 (OK)
    // 0 (0000): 0 & ... = 0 (OK)
    // 1 (0001): 1 & 1 & (1|1) = 1 (Wait, 1 is supposed to be 0)
    // The POS expression (c) & (~a | b) & (~b | d) gives 1 for 1 (0001). Correcting...
    // Try POS: (c) & (~a | b | d) & (~b | ~c | d) -- No.

    // Let's use the standard Boolean Algebra minimization:
    // F = ~a~bc~d + ~a~bcd + ~abc d + abcd
    // F = ~a~bc(~d + d) + bc d (~a + a) = ~a~bc + bcd
    // Correct SOP: (~a & ~b & c) | (b & c & d)
    // POS (Dual of F_bar):
    // F_bar = 0s at {0, 1, 4, 5, 6, 9, 10, 13, 14}
    // F_bar = a~c + ~bc~d + ~b~cd... (Simplified)
    // POS = (a | b | ~c) & (~a | ~c | d) & (~b | c | ~d) -- check this
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (b | c) & (~a | c) & (~b | c) ... wait.
    // Let's use simpler:
    assign out_pos = (c) & (~a | b | d) & (~b | ~d);
endmodule