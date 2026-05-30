module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Based on K-map:
    // cd\ab | 00 | 01 | 10 | 11
    // 00    | 0  | d  | 1  | 1
    // 01    | 0  | 0  | d  | d
    // 11    | 1  | 0  | 1  | 1
    // 10    | 1  | 0  | 1  | 1
    
    // Choosing d = 0 for 00/01 and d = 1 for 01/11, 01/10
    // Let's simplify with K-map logic:
    // Groups:
    // 1. (a=1) -> a covers (1,0),(1,1),(1,0),(1,1) (10, 11 columns)
    // 2. (c=1, b=0) -> covers (1,1,0,0),(1,1,1,0) (11,10 rows)
    // Actually, simple way:
    // out = a | (~c & ~b) is not quite right.
    
    // Let's write the Karnaugh map:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0 (d=0)
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0 (d=0)
    // 0 1 1 1 | 0 (d=0)
    // 1 0 0 0 | 1
    // 1 0 0 1 | 0
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    
    // Logic function from truth table (don't cares set to 0):
    // out = (~a & ~b & c) | (a & ~c & ~d) | (a & c) | (a & b & ~d)
    // Simplification: out = a | (~a & ~b & c)
    
    assign out = a | (~b & c);
endmodule
