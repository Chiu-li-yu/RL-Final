module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Let's re-verify the K-Map.
    // 2 (0010), 7 (0111), 15 (1111)
    // 3, 8, 11, 12 = X
    // K-map:
    //      cd 00 01 11 10
    // ab
    // 00      0  0  X  1
    // 01      0  0  1  0
    // 11      X  0  1  0
    // 10      X  0  X  0

    // Groups for SOP:
    // (a,b,c,d) = (0,0,1,0) -> ~a & ~b & c & ~d
    // (a,b,c,d) = (0,1,1,1) and (1,1,1,1) -> b & c & d
    // There is no other group.

    // Let's re-verify POS:
    // F(a,b,c,d) = ΠM(0,1,4,5,6,9,10,13,14)
    // Let's look at the groups of 0s:
    // (0,0,0,0) (0,0,0,1) (0,1,0,0) (0,1,0,1) -> (a+c) ?? No.
    // (0,0,0,0) (0,0,0,1) (1,0,0,0) (1,0,0,1) -> (b+c) ??
    // Let's look at the groups:
    // Group 1: 0000, 0001, 0100, 0101 (a=0, c=0) -> (a+c)
    // Group 2: 0000, 0010, 1000, 1010 (b=0, d=0) -> (b+d) -- Wait, this is 1.

    // Let's use logic for each output.
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);
    assign out_pos = (c) & (~a | b) & (b | ~d) & (~a | ~d);
endmodule
