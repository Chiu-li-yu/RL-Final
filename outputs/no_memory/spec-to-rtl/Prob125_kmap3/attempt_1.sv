module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map provided:
    //         ab
    // cd   01 00 10 11
    // 00 | d | 0 | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 0 | 1 | 1 | 1 |
    
    // Truth Table mapping:
    // ab | cd | out
    // 01 | 00 | d(0)
    // 01 | 01 | 0
    // 01 | 11 | 0
    // 01 | 10 | 0
    // 00 | 00 | 0
    // 00 | 01 | 0
    // 00 | 11 | 1
    // 00 | 10 | 1
    // 10 | 00 | 1
    // 10 | 01 | d(1)
    // 10 | 11 | 1
    // 10 | 10 | 1
    // 11 | 00 | 1
    // 11 | 01 | d(1)
    // 11 | 11 | 1
    // 11 | 10 | 1
    
    // Simplification:
    // out = a | (~a & ~b & c)
    // If a=1: out=1
    // If a=0, b=0: out=c
    // If a=0, b=1: out=0
    
    assign out = a | (~b & c);

endmodule
