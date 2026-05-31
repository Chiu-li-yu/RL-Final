module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // K-map table construction
    // a b | c d | q
    // 0 0 | 0 0 | 1
    // 0 0 | 0 1 | 0
    // 0 0 | 1 0 | 0
    // 0 0 | 1 1 | 1
    // 0 1 | 0 0 | 0
    // 0 1 | 0 1 | 1
    // 0 1 | 1 0 | 1
    // 0 1 | 1 1 | 0
    // 1 0 | 0 0 | 0
    // 1 0 | 0 1 | 1
    // 1 0 | 1 0 | 1
    // 1 0 | 1 1 | 0
    // 1 1 | 0 0 | 1
    // 1 1 | 0 1 | 0
    // 1 1 | 1 0 | 0
    // 1 1 | 1 1 | 1

    // This is equivalent to an XNOR gate tree: q = ~(a ^ b ^ c ^ d)
    // Let's verify:
    // 0 0 0 0 -> ~(0^0^0^0) = ~0 = 1 (Match)
    // 0 0 0 1 -> ~(0^0^0^1) = ~1 = 0 (Match)
    // 0 0 1 1 -> ~(0^0^1^1) = ~0 = 1 (Match)
    // 0 1 0 1 -> ~(0^1^0^1) = ~0 = 1 (Match)
    // 1 1 1 1 -> ~(1^1^1^1) = ~0 = 1 (Match)
    
    assign q = !(a ^ b ^ c ^ d);

endmodule
