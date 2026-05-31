module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Analysis of the truth table:
    // a b c d | q
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 1
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 0
    // 1 0 0 1 | 0
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    
    // Looking at the patterns:
    // If c is 1, q is always 1 (regardless of a, b, d)
    // If c is 0, q = b.
    // Let's verify:
    // c=1: q=1. Matches all cases.
    // c=0: q=b.
    //   a=0, c=0, b=0, d=0 -> q=0 (Matches: 0 0 0 0 -> 0)
    //   a=0, c=0, b=0, d=1 -> q=0 (Matches: 0 0 0 1 -> 0)
    //   a=0, c=0, b=1, d=0 -> q=1 (Matches: 0 1 0 0 -> 1)
    //   a=0, c=0, b=1, d=1 -> q=1 (Matches: 0 1 0 1 -> 1)
    //   a=1, c=0, b=0, d=0 -> q=0 (Matches: 1 0 0 0 -> 0)
    //   a=1, c=0, b=0, d=1 -> q=0 (Matches: 1 0 0 1 -> 0)
    //   a=1, c=0, b=1, d=0 -> q=1 (Matches: 1 1 0 0 -> 1)
    //   a=1, c=0, b=1, d=1 -> q=1 (Matches: 1 1 0 1 -> 1)
    
    // So logic is: q = c | b
    
    always @(*) begin
        q = c | b;
    end
endmodule
