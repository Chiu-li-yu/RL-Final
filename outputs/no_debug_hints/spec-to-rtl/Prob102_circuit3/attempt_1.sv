module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Based on the provided truth table:
    // a b c d | q
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 0
    // 0 0 1 1 | 0
    // 0 1 0 0 | 0
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 0
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    
    // Pattern observation:
    // q is high if (a OR b) is high AND d is high.
    // Let's verify:
    // (a=0, b=1) and d=1 -> q=1
    // (a=1, b=0) and d=1 -> q=1
    // (a=1, b=1) and d=1 -> q=1
    // (a=0, b=0) and d=1 -> q=0
    // Also q depends on c? Let's check c=0/1.
    // 0 1 0 1 | 1
    // 0 1 1 1 | 1
    // 1 0 0 1 | 1
    // 1 0 1 1 | 1
    // 1 1 0 1 | 1
    // 1 1 1 1 | 1
    // It seems q is independent of c.
    // q = (a | b) & d

    always @(*) begin
        q = (a | b) & d;
    end

endmodule
