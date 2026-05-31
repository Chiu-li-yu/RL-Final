module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table (ab, cd):
    //      00 01 11 10
    // 00 | 1  1  0  1 |
    // 01 | 1  0  0  1 |
    // 11 | 0  1  1  1 |
    // 10 | 1  1  0  0 |
    
    // Truth table:
    // a b c d | out
    // 0 0 0 0 | 1
    // 0 0 0 1 | 1
    // 0 0 1 0 | 1
    // 0 0 1 1 | 0
    // 0 1 0 0 | 1
    // 0 1 0 1 | 0
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 0
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1

    // Logic extraction:
    // out = (~a & ~b & ~c) | (~a & ~b & ~d) | (~a & ~c & ~d) | ...
    // Using minterms (where out == 1):
    // 0000, 0001, 0010, 0100, 0110, 0111, 1000, 1001, 1011, 1111
    
    assign out = (~a & ~b & ~c & ~d) | 
                 (~a & ~b & ~c &  d) | 
                 (~a & ~b &  c & ~d) | 
                 (~a &  b & ~c & ~d) | 
                 (~a &  b &  c & ~d) | 
                 (~a &  b &  c &  d) | 
                 ( a & ~b & ~c & ~d) | 
                 ( a & ~b & ~c &  d) | 
                 ( a & ~b &  c &  d) | 
                 ( a &  b &  c &  d);
endmodule
