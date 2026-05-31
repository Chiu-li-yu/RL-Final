module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minterms (Output 1): 2 (0010), 7 (0111), 15 (1111)
    // Don't cares: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    
    // K-map (a,b,c,d):
    //      cd 00 01 11 10
    // ab 00    0  0  x  1  (2 is 0010, 3 is 0011)
    // ab 01    0  0  1  0  (7 is 0111)
    // ab 11    x  x  1  x  (15 is 1111, 12 is 1100, 13 is 1101)
    // ab 10    x  0  x  0  (8 is 1000, 11 is 1011)
    
    // Groups for SOP:
    // 1. (2, 3) = ~a ~b c
    // 2. (7, 15, 11, 3) = c d 
    // Wait, 3 is in both? Yes.
    // SOP = (~a & ~b & c) | (c & d)
    // SOP = c & (~a & ~b | d)
    assign out_sop = c & (~a & ~b | d);
    
    // For POS:
    // 0s are 0, 1, 4, 5, 6, 9, 10, 13, 14
    // F = c & (~a & ~b | d)
    // F = c & (~a | d) & (~b | d)
    // POS = c & (~a | d) & (~b | d)
    assign out_pos = c & (~a | d) & (~b | d);

endmodule
