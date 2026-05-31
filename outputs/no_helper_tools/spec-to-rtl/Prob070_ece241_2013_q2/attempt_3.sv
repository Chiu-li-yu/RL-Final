module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
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

    // SOP: (~a & ~b & c) | (b & c & d) | (a & c & d)
    // Simplify SOP: c & (~a & ~b | b & d | a & d)
    // c & (~a & ~b | d & (a | b))
    assign out_sop = c & (~a & ~b | d & (a | b));

    // POS:
    // Out is 1 when (c=1 AND (a=0, b=0 OR a=1, d=1 OR b=1, d=1))
    // Out is 0 when c=0 OR (c=1 AND NOT(...) )
    // F = c & (~a & ~b | d & (a | b))
    // F = c & (~a | d) & (~b | d) & (a | b)
    // F' = ~c | (a & ~d) | (b & ~d) | (~a & ~b)
    // Using Product of Sums:
    // The expression for 0 is (c=0 OR something)
    // Look for maxterms:
    // Out=0 when c=0 OR (a=1, b=1, d=0) OR (a=0, b=0, d=1) ...
    // POS = (c) & (a | b | ~d) & (~a | ~b | ~d)  <-- Let's test this.
    // 2 (0010): 1 * (0|0|1) * (1|1|1) = 1 * 1 * 1 = 1. (Correct)
    // 7 (0111): 1 * (0|1|0) * (1|0|0) = 1 * 1 * 0 = 0. (Wait, 7 should be 1)
    
    // Correct POS from K-map:
    // F = (c) * (a | b | ~d) * (~a | ~b | d)?
    // Let's test 7 (0111): 1 * (0|1|0) * (1|0|1) = 1 * 1 * 1 = 1. (Correct)
    // Test 15 (1111): 1 * (1|1|0) * (0|0|1) = 1 * 1 * 1 = 1. (Correct)
    // Test 2 (0010): 1 * (0|0|1) * (1|1|0) = 1 * 1 * 1 = 1. (Correct)
    // Test 0 (0000): 0 * (0|0|1) * (1|1|0) = 0. (Correct)
    // Test 9 (1001): 1 * (1|0|0) * (0|1|1) = 1 * 1 * 1 = 1. (Wait, 9 should be 0)
    
    // Let's use logic gates to implement truth table directly.
    // Out = (a&b&c&d) | (~a&b&c&d) | (~a&~b&c&~d)
    // Simplified: (c&d&(a|b)) | (~a&~b&c&~d)
    
    assign out_pos = (c) & (a | b | ~d) & (~a | ~b | d) & (~a | b | ~d) & (a | ~b | ~d);

endmodule
