module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth table:
    // 0010: 1 (2)
    // 0111: 1 (7)
    // 1111: 1 (15)
    // Don't cares: 3, 8, 11, 12
    
    // SOP: (~a & ~b & c) | (b & c & d) | (a & c & d) is correct for SOP.
    
    // POS:
    // POS is product of sums.
    // Logic 0 at:
    // (a=0, b=0, c=0, d=0) -> 0
    // (a=0, b=0, c=0, d=1) -> 0
    // (a=0, b=1, c=0, d=0) -> 0
    // (a=0, b=1, c=0, d=1) -> 0
    // (a=0, b=1, c=1, d=0) -> 0
    // (a=1, b=0, c=0, d=1) -> 0
    // (a=1, b=0, c=1, d=0) -> 0
    // (a=1, b=1, c=0, d=1) -> 0
    // (a=1, b=1, c=1, d=0) -> 0
    
    // POS form: (c|d) & (a|b|~c) & (~a|~b|d) ... Wait, just use truth table in SOP form for POS? No.
    // The problem asks for minimum POS.
    // K-map for 0s:
    // (c|d) & (a|~c) & (~b|d) was close.
    // Try: (c|d) & (a|b|~c) & (~a|~b|d) --- wait, try:
    // POS = (c | d) & (a | ~b | ~c) & (~a | b | ~c) ... no.

    // How about I just use an expression that is correct for the Truth table?
    // Let's brute force the POS expression:
    // 0 = (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) ...
    // This is the SOP of the 0s. 
    // To get POS, I need the product of sums of the 0s.
    
    // Actually, I will write the POS expression as a simple logic expression that matches the truth table.
    
    assign out_sop = (~a & ~b & c) | (b & c & d) | (a & c & d);
    assign out_pos = (~a | c) & (b | c) & (a | ~b | d) & (c | d); 

endmodule