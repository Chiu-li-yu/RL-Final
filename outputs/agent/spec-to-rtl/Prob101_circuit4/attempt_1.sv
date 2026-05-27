module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table analysis:
    // q = 1 when:
    // (a=0, b=0, c=1, d=0) -> 1
    // (a=0, b=0, c=1, d=1) -> 1
    // (a=0, b=1, c=0, d=0) -> 1
    // (a=0, b=1, c=0, d=1) -> 1
    // (a=0, b=1, c=1, d=0) -> 1
    // (a=0, b=1, c=1, d=1) -> 1
    // (a=1, b=0, c=1, d=0) -> 1
    // (a=1, b=0, c=1, d=1) -> 1
    // (a=1, b=1, c=0, d=0) -> 1
    // (a=1, b=1, c=0, d=1) -> 1
    // (a=1, b=1, c=1, d=0) -> 1
    // (a=1, b=1, c=1, d=1) -> 1
    
    // Simplified logic expression:
    // When a=0: (b=1) OR (c=1)
    // When a=1: (b=1) OR (c=1)
    // Actually, looking closer:
    // When a=0: q = b | c
    // When a=1: q = b | c
    // Wait, let's re-verify:
    // a=0, b=0, c=0, d=0 -> q=0
    // a=0, b=0, c=0, d=1 -> q=0
    // a=0, b=0, c=1, d=0 -> q=1
    // a=0, b=0, c=1, d=1 -> q=1
    // a=0, b=1, c=0, d=0 -> q=1
    // a=0, b=1, c=0, d=1 -> q=1
    // a=0, b=1, c=1, d=0 -> q=1
    // a=0, b=1, c=1, d=1 -> q=1
    // This is simply q = b | c.
    
    assign q = b | c;
endmodule
