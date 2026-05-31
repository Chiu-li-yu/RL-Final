module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // K-Map Truth Table (a,b,c,d)
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

    // SOP (1s at 2, 7, 15; Xs at 3, 8, 11, 12)
    // K-Map simplification:
    // Group 1 (2,3): ~a & ~b & c
    // Group 2 (7,15): b & c & d
    // Group 3 (8,12): a & ~c & ~d (Wait, 8,12 is 1000 and 1100)
    // Let's re-verify min-SOP:
    // F = (~a & ~b & c) + (b & c & d) + (a & ~c & ~d)? No.
    // Let's group 1s:
    // (0,0,1,0) [2]
    // (0,1,1,1) [7]
    // (1,1,1,1) [15]
    // With 3, 8, 11, 12 as X:
    // F = (~a & ~b & c) + (b & c & d) + (a & ~c & ~d)
    // Wait, let's simplify carefully.
    
    // SOP logic:
    // 2(0010), 3(0011), 7(0111), 15(1111), 8(1000), 12(1100), 11(1011)
    // Groups:
    // 1. (0010, 0011) -> ~a & ~b & c
    // 2. (0111, 1111) -> b & c & d
    // 3. (1000, 1100) -> a & ~c & ~d
    
    assign out_sop = (~a & ~b & c) | (b & c & d) | (a & ~c & ~d);

    // POS logic:
    // Inverse K-Map (0s at 0, 1, 4, 5, 6, 9, 10, 13, 14)
    // Simplified POS:
    // (~a + c) * (~b + c) * (~c + d) * (~a + b + d)? Let's use SOP to POS conversion.
    // Based on standard K-Map minimization:
    assign out_pos = (~a | ~c | d) & (a | ~b | c) & (~b | c | d);

endmodule
