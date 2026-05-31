module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minterms: 2, 7, 15
    // Don't cares: 3, 8, 11, 12
    // SOP: (~a & ~b & c & ~d) | (b & c & d) | (a & c & d)
    // Simplified SOP: (~a & ~b & c & ~d) | (c & d & (a | b))
    assign out_sop = (~a & ~b & c & ~d) | (c & d & (a | b));

    // POS:
    // F = (c) * (a | b | ~d) * (~a | ~b | d) ... No, just map the 0s.
    // 0s: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // POS: (c) * (~a | ~b | ~d) * (a | b | ~d) ...
    // Let's use the SOP form to derive POS:
    // POS = (c) * (a | ~b) * (~a | b) * (a | b | ~d) ... 
    
    // Actually, minterm/maxterm expansion is safer:
    // 0 = (~a+~b+~c+~d)
    // 1 = (~a+~b+~c+d)
    // 4 = (~a+b+~c+~d)
    // 5 = (~a+b+~c+d)
    // 6 = (~a+b+c+~d)
    // 9 = (a+~b+~c+d)
    // 10 = (a+~b+c+~d)
    // 13 = (a+b+~c+d)
    // 14 = (a+b+c+~d)
    // Let's group them:
    // F = (c) & (a | ~b) & (~a | b | ~d) & (~a | ~d) ...
    // Let's use a simpler way:
    // F = c & (a & d | b & d | ~a & ~b & ~d)
    // F = c & (d & (a | b) | ~a & ~b & ~d)
    // POS: F = c & (a | b | ~d) & (~a | ~b | d) & (a | ~b | d) & (~a | b | d) ... this is hard.
    
    // Let's re-verify the table:
    // 2 (0010) = 1
    // 7 (0111) = 1
    // 15(1111) = 1
    // All others = 0
    // SOP: c & (~a & ~b & ~d | d & (a | b))
    // POS: (c) & (a | ~b | d) & (~a | b | d) & (~a | ~b | ~d)
    
    assign out_pos = (c) & (a | ~b | d) & (~a | b | d) & (~a | ~b | ~d);
    
endmodule
