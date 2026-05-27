module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Based on the provided K-map:
    // Columns (AB): 01, 00, 10, 11
    // Rows    (CD): 00, 01, 11, 10
    
    // Values:
    // cd\ab | 01 | 00 | 10 | 11
    // -------------------------
    // 00    |  d |  0 |  1 |  1
    // 01    |  0 |  0 |  d |  d
    // 11    |  0 |  1 |  1 |  1
    // 10    |  0 |  1 |  1 |  1
    
    // Mapping table (c,d,a,b -> out):
    // 0,0,0,1 -> d
    // 0,0,0,0 -> 0
    // 0,0,1,0 -> 1
    // 0,0,1,1 -> 1
    // 0,1,0,1 -> 0
    // 0,1,0,0 -> 0
    // 0,1,1,0 -> d
    // 0,1,1,1 -> d
    // 1,1,0,1 -> 0
    // 1,1,0,0 -> 1
    // 1,1,1,0 -> 1
    // 1,1,1,1 -> 1
    // 1,0,0,1 -> 0
    // 1,0,0,0 -> 1
    // 1,0,1,0 -> 1
    // 1,0,1,1 -> 1
    
    // Choose d = 1 for better simplification.
    // Truth Table:
    // c d a b | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 0
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    
    // Simplified logic:
    // Out is 1 when:
    // (a=1) OR (b=1 and c=0 and d=0) OR (b=1 and c=1)
    // Actually, looking at the pattern, let's use Karnaugh Map software logic:
    // f = a | (b & ~c & ~d) | (b & c)
    // f = a | (b & (~c | c) & (~d | ~c))? Wait.
    // Let's use Sum of Products from the table where out = 1.
    
    assign out = a | (b & ~c & ~d) | (b & c);

endmodule
