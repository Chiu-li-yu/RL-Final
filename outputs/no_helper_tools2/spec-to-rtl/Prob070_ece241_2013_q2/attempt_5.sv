module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Truth table logic from problem source (common ECE241 problem):
    // 2 (0010), 7 (0111), 15 (1111) are 1.
    // 3, 8, 11, 12 are x.
    // SOP: (a'c) + (bcd)
    // POS: (c) & (b+d) & (a'+b) ... Wait, that was my second try.
    // Let's use:
    // SOP: (~a & ~b & c) | (b & c & d)
    // POS: (c) & (b | d) & (~a | b)
    
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = c & (b | d) & (~a | b);
endmodule