module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Minimized SOP: 
    // 1s: 2, 7, 15
    // Xs: 3, 8, 11, 12
    // K-map (1s):
    // 2 (0010) + 3 (0011) = ~a & ~b & c
    // 7 (0111) + 15 (1111) = b & c & d
    // 11 (1011) + 15 (1111) = a & c & d
    // 8 (1000) + 12 (1100) = a & ~c & ~d
    // Wait, the specification says:
    // "generates a logic-1 when 2, 7, or 15 appears"
    // "a logic-0 when 0, 1, 4, 5, 6, 9, 10, 13, 14 appears"
    // "3, 8, 11, 12 are don't cares"
    
    // So 1s are 2, 7, 15. Don't cares are 3, 8, 11, 12.
    // 1s: 0010, 0111, 1111
    // Xs: 0011, 1000, 1011, 1100
    // SOP: (~a & ~b & c) | (b & c & d) | (a & c & d) -> is this minimized?
    // (~a & ~b & c) | (c & d & (a | b))
    
    assign out_sop = (~a & ~b & c) | (c & d & (a | b));
    
    // POS: K-map zeros:
    // Zeros at: 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
    // POS = (c) & (a | ~b | d) & (~a | b | d) & (~a | ~c) ? No.
    // Let's use the standard canonical POS and then simplify.
    // POS = (a+b+c+d)(a+b+c+~d)(a+~b+c+d)(a+~b+c+~d)(a+~b+~c+d)(~a+b+c+~d)(~a+b+~c+d)(~a+~b+c+~d)(~a+~b+~c+d)
    
    // POS = (c) & (~a | d) & (a | ~b) & (b | ~d) ...
    // Let's try:
    assign out_pos = c & (~a | b) & (a | d) & (~b | ~d);
    
endmodule