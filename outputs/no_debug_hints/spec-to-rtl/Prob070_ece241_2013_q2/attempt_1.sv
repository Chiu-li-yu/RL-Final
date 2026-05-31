module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // SOP logic:
    // Minterms: 2 (0010), 7 (0111), 15 (1111)
    // Don't Cares: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    // K-map grouping:
    // (0010, 0011) -> ~a & ~b & c
    // (0111, 1111) -> b & c & d
    assign out_sop = (~a & ~b & c) | (b & c & d);

    // POS logic:
    // Dual of logic for 0s. 
    // Using Product of Sums:
    // (~a | c) & (b | c | d)
    // Let's check:
    // 2 (0010): (~0|1) & (0|1|0) = (1|1) & (1) = 1*1 = 1. OK.
    // 7 (0111): (~0|1) & (1|1|1) = 1 * 1 = 1. OK.
    // 15 (1111): (~1|1) & (1|1|1) = (0|1) * 1 = 1. OK.
    // 0 (0000): (~0|0) & (0|0|0) = 1 * 0 = 0. OK.
    // 6 (0110): (~0|1) & (1|1|0) = 1 * 1 = 1? WAIT. 6 is 0110. 
    // My POS expression might be wrong for 6. Let's re-verify.
    // 6 is 0110. a=0, b=1, c=1, d=0.
    // (~a|c) = (~0|1) = 1. (b|c|d) = (1|1|0) = 1. 1*1 = 1. But output should be 0.
    // Need to fix POS.
    
    // Correcting POS:
    // Let's find POS by factoring:
    // SOP = (~a & ~b & c) | (b & c & d) = c * ((~a & ~b) | (b & d))
    // Using distributive law: (c) & (~a & ~b | b) & (~a & ~b | d)
    // = c & (~a | b) & (~b | b) & (~a | d) & (~b | d)
    // = c & (~a | b) & 1 & (~a | d) & (~b | d)
    // = c & (~a | b) & (~a | d) & (~b | d)
    
    assign out_pos = c & (~a | b) & (~a | d) & (~b | d);

endmodule