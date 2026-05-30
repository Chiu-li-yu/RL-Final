module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth table:
    // 0000 0
    // 0001 0
    // 0010 1
    // 0011 X
    // 0100 0
    // 0101 0
    // 0110 0
    // 0111 1
    // 1000 X
    // 1001 0
    // 1010 0
    // 1011 X
    // 1100 X
    // 1101 0
    // 1110 0
    // 1111 1

    // SOP: (~a & ~b & c) | (b & c & d) | (a & c & d)
    // Testing logic for POS:
    // Let's use K-Map for 0s.
    // 0s at 0, 1, 4, 5, 6, 9, 10, 13, 14
    // POS: (c|d) & (a|~c) & (~b|d)
    
    assign out_sop = (~a & ~b & c) | (b & c & d) | (a & c & d);
    assign out_pos = (c | d) & (a | ~c) & (~b | d);

endmodule