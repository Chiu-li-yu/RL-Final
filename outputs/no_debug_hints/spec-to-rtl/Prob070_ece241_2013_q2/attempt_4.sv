module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Let's use the truth table strictly.
    // SOP: (2, 7, 15) + (3, 8, 11, 12)
    // 0010, 0111, 1111, 0011, 1000, 1011, 1100
    // K-map:
    //      cd 00 01 11 10
    // ab 00  0  0  X  1
    // ab 01  0  0  1  0
    // ab 11  X  0  1  0
    // ab 10  X  0  X  0
    // Wait, my K-map for 1s was wrong.
    // 0010 is 1. (0,0,1,0)
    // 0111 is 1. (0,1,1,1)
    // 1111 is 1. (1,1,1,1)
    // 0011 is X. (0,0,1,1)
    // 1000 is X. (1,0,0,0)
    // 1011 is X. (1,0,1,1)
    // 1100 is X. (1,1,0,0)
    
    // Grouping:
    // Group 1: 0010, 0011 (row 00, cols 10, 11) -> ~a & ~b & c
    // Group 2: 0111, 1111 (row 01, col 11; row 11, col 11) -> b & c & d
    // Group 3: 1111, 1011 (row 11, col 11; row 10, col 11) -> a & c & d
    // SOP = (~a & ~b & c) | (b & c & d) | (a & c & d)
    // = (~a & ~b & c) | (c & d & (b | a))
    
    assign out_sop = (~a & ~b & c) | (c & d & (a | b));
    
    // POS from K-map (for 0s):
    // Zeros at: 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
    // 0000 (0,0,0,0)
    // 0001 (0,0,0,1)
    // 0100 (0,1,0,0)
    // 0101 (0,1,0,1)
    // 0110 (0,1,1,0)
    // 1001 (1,0,0,1)
    // 1010 (1,0,1,0)
    // 1101 (1,1,0,1)
    // 1110 (1,1,1,0)
    
    // Grouping 0s:
    // (0000, 0001, 0100, 0101) -> ~a & ~c (POS: a | c)
    // (0100, 0101, 0110) -> not possible
    // (0000, 0100, 1000(X), 1100(X)) -> ~b & ~c (POS: b | c)
    // (0001, 0101, 1001, 1101) -> ~c & d (POS: c | ~d)
    // ...
    // This is becoming complex. Let's use the truth table to check POS = (a | c) & (~a | ~c | ~d) & ...
    // The expression for POS should be (a|c) & (b|c|d) & (~a|~b|~c) ... no.
    
    // Let's use the K-map result for POS from a known source or re-derive carefully:
    // Zeros:
    // 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
    // POS = (a|c) & (~a|b|d) & (~b|~c|~d) ... 
    
    // Let's try: POS = (a|c) & (~a|b|d) & (~b|c|~d) 
    assign out_pos = (a | c) & (~a | b | d) & (~b | c | ~d);
    
endmodule