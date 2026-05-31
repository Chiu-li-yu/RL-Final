module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table analysis:
    // a b c d | q
    // 0 0 0 0 | 1
    // 0 0 0 1 | 0
    // 0 0 1 0 | 0
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 0
    // 1 0 0 0 | 0
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 0
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1
    
    // Pattern: q = a ^ b ^ c ^ d ^ 1
    // (XNOR gate)
    assign q = !(a ^ b ^ c ^ d);
endmodule