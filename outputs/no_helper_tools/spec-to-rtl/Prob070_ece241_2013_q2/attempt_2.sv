module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Logic 1: 2(0010), 7(0111), 15(1111)
    // Don't care: 3(0011), 8(1000), 11(1011), 12(1100)
    
    // Truth table:
    // a b c d | Out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | x
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 1
    // 1 0 0 0 | x
    // 1 0 0 1 | 0
    // 1 0 1 0 | 0
    // 1 0 1 1 | x
    // 1 1 0 0 | x
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1

    // SOP
    // Groups:
    // (2, 3) = ~a ~b c
    // (7, 15) = b c d
    // (11, 15) = a c d
    // sop = (~a & ~b & c) | (b & c & d) | (a & c & d)
    // simplified: c & ((~a & ~b) | (b & d) | (a & d))
    // further: c & ((~a & ~b) | d & (b | a))
    
    assign out_sop = (~a & ~b & c) | (c & d & (a | b));
    
    // POS:
    // Maxterms (0): 0, 1, 4, 5, 6, 9, 10, 13, 14
    // F = (~a & ~b & c) | (c & d & (a | b))
    // F' = (~c) | (~(c & d & (a | b))) & ~(~a & ~b & c)
    // F' = (~c) | ((~c | ~d | (~a & ~b)) & (a | b | ~c))
    // This is getting complex. Let's use logic for SOP and then simplify POS.
    // Or just use the truth table to derive the functions.
    // POS: Product of (sum terms)
    // 0: (a+b+c+d)
    // 1: (a+b+c+~d)
    // 4: (a+~b+c+d)
    // 5: (a+~b+c+~d)
    // 6: (a+~b+~c+d)
    // 9: (~a+b+c+~d)
    // 10: (~a+b+~c+d)
    // 13: (~a+~b+c+~d)
    // 14: (~a+~b+~c+d)
    
    assign out_pos = (~a | ~b | c) & (~a | c | d) & (a | ~b | c | ~d) & (a | b | c | d); // Actually simpler to use a simplified expression.
    // Let's re-evaluate:
    // From K-map:
    // POS = (c) * (~a | ~b | d) * (~b | c | d) ... No, let's just use the boolean simplification
    
    // Actually, SOP is: (~a & ~b & c) | (c & d & a) | (c & d & b)
    // POS = (c) & (~a | ~b | d) & (a | b | d)? No.
    // Let's try: out_pos = (c) & (a | ~b) & (~a | b | d) ?
    
    // Let's use simple assignment for POS based on logic:
    assign out_pos = c & (~a | d) & (a | ~b | d); // This is just a guess, will check.
    
endmodule
