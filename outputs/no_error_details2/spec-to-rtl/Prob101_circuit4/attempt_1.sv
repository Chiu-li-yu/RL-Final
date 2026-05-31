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
    
    // Pattern observation:
    // If c is 1, q is 1 (except some edge cases?)
    // Actually:
    // If c=1: q=1
    // If b=1: q=1
    // If c=0 and b=0: q=0
    // This matches: q = b | c
    
    // Let's verify:
    // c=1 -> q=1
    // b=1 -> q=1
    // b=0, c=0 -> q=0
    //
    // Check table:
    // 0 0 0 0 | 0 (b=0, c=0) OK
    // 0 0 0 1 | 0 (b=0, c=0) OK
    // 0 0 1 0 | 1 (c=1) OK
    // 0 0 1 1 | 1 (c=1) OK
    // 0 1 0 0 | 1 (b=1) OK
    // 0 1 0 1 | 1 (b=1) OK
    // 0 1 1 0 | 1 (b=1, c=1) OK
    // 0 1 1 1 | 1 (b=1, c=1) OK
    // 1 0 0 0 | 0 (b=0, c=0) OK
    // 1 0 0 1 | 0 (b=0, c=0) OK
    // 1 0 1 0 | 1 (c=1) OK
    // 1 0 1 1 | 1 (c=1) OK
    // 1 1 0 0 | 1 (b=1) OK
    // 1 1 0 1 | 1 (b=1) OK
    // 1 1 1 0 | 1 (b=1, c=1) OK
    // 1 1 1 1 | 1 (b=1, c=1) OK
    
    always @(*) begin
        q = b | c;
    end
endmodule
