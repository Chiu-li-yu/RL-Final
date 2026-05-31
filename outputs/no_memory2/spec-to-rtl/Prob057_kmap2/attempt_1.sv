module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table (cd | ab):
    //      00 01 11 10
    // 00 | 1  1  0  1 |
    // 01 | 1  0  0  1 |
    // 11 | 0  1  1  1 |
    // 10 | 1  1  0  0 |
    
    // Sum of Products (SOP) extraction:
    // out = (~a&~b&~c&~d) | (~a&b&~c&~d) | (a&~b&~c&~d) | 
    //       (~a&~b&~c&d) | (a&~b&~c&d) | 
    //       (~a&b&c&d) | (a&b&c&d) | (a&~b&c&d) |
    //       (~a&~b&c&~d) | (~a&b&c&~d) | (a&b&c&~d)

    assign out = (~a & ~b & ~c & ~d) | 
                 (~a &  b & ~c & ~d) | 
                 ( a & ~b & ~c & ~d) | 
                 (~a & ~b & ~c &  d) | 
                 ( a & ~b & ~c &  d) | 
                 (~a &  b &  c &  d) | 
                 ( a &  b &  c &  d) | 
                 ( a & ~b &  c &  d) | 
                 (~a & ~b &  c & ~d) | 
                 (~a &  b &  c & ~d) | 
                 ( a &  b &  c & ~d);

endmodule
