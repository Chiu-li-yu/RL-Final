module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table (cd row, ab col):
    //      ab 01 00 10 11
    // cd 00   d  0  1  1
    //    01   0  0  d  d
    //    11   0  1  1  1
    //    10   0  1  1  1

    // Mapping inputs (c, d, a, b) to values (cd row, ab col):
    // cd: c, d
    // ab: a, b
    
    // (c, d, a, b) | out
    // 0 0 0 1 | d -> 1
    // 0 0 0 0 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    
    // 0 1 0 1 | 0
    // 0 1 0 0 | 0
    // 0 1 1 0 | d -> 1
    // 0 1 1 1 | d -> 1
    
    // 1 1 0 1 | 0
    // 1 1 0 0 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    
    // 1 0 0 1 | 0
    // 1 0 0 0 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1

    // Let's refine based on the inputs provided:
    // (c,d) = 0,0: out = a | b
    // (c,d) = 0,1: out = a & b (d is 1, let's pick 1 for 0,1,1,0 and 0,1,1,1)
    // (c,d) = 1,1: out = a | ~b
    // (c,d) = 1,0: out = a | ~b

    // Logic:
    // If (c,d) = 00: a|b
    // If (c,d) = 01: a&b
    // If (c,d) = 1x: a|~b
    
    // Looking at the values:
    // c d a b | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 0
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1

    // It seems out is 1 when (a=1) OR (a=0 and b=1 and c=0 and d=0) OR (a=0 and b=0 and c=1)
    
    assign out = (a) | (~a & b & ~c & ~d) | (~a & ~b & c);

endmodule
