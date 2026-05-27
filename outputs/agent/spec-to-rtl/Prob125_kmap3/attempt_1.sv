module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Karnaugh map input representation:
    // row (c d): 00, 01, 11, 10
    // col (a b): 00, 01, 11, 10
    
    // Values provided:
    // cd\ab | 00 | 01 | 11 | 10
    // -------------------------
    // 00    |  0 |  d |  1 |  1
    // 01    |  0 |  0 |  d |  d
    // 11    |  1 |  0 |  1 |  1
    // 10    |  1 |  0 |  1 |  1
    
    // Note: The input K-map table description in prompt:
    //               ab
    //    cd   01  00  10  11
    //    00 | d | 0 | 1 | 1 |
    //    01 | 0 | 0 | d | d |
    //    11 | 0 | 1 | 1 | 1 |
    //    10 | 0 | 1 | 1 | 1 |
    
    // Mapping:
    // (c,d,a,b) -> out
    // 0,0,0,0 -> 0
    // 0,0,0,1 -> d
    // 0,0,1,0 -> 1
    // 0,0,1,1 -> 1
    // 0,1,0,0 -> 0
    // 0,1,0,1 -> 0
    // 0,1,1,0 -> d
    // 0,1,1,1 -> d
    // 1,1,0,0 -> 0
    // 1,1,0,1 -> 1
    // 1,1,1,0 -> 1
    // 1,1,1,1 -> 1
    // 1,0,0,0 -> 0
    // 1,0,0,1 -> 1
    // 1,0,1,0 -> 1
    // 1,0,1,1 -> 1

    // Simplification strategy (setting d=1 if beneficial):
    // Using sum of products or map simplification:
    // out = a | (~c & ~d & b) | (c & b) | (c & a) ... etc.
    // Let's implement directly from the table logic.
    
    assign out = (~c & ~d & a) | (~c & ~d & b) | (c & a) | (c & b);

endmodule
