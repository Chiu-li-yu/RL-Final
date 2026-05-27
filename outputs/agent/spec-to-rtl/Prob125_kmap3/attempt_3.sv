module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map table from prompt:
    // AB: 01, 00, 10, 11
    // CD: 00, 01, 11, 10
    
    //      | AB=01 | AB=00 | AB=10 | AB=11
    // -----+-------+-------+-------+-------
    // CD=00|   d   |   0   |   1   |   1
    // CD=01|   0   |   0   |   d   |   d
    // CD=11|   0   |   1   |   1   |   1
    // CD=10|   0   |   1   |   1   |   1

    // Let's write out the full truth table based on (a, b, c, d)
    // a b c d | out
    // 0 0 0 0 | 0 (from CD=00, AB=00)
    // 0 0 0 1 | 0 (from CD=01, AB=00)
    // 0 0 1 0 | 1 (from CD=10, AB=00)
    // 0 0 1 1 | 1 (from CD=11, AB=00)
    // 0 1 0 0 | d=1
    // 0 1 0 1 | 0 (from CD=01, AB=01)
    // 0 1 1 0 | 0 (from CD=10, AB=01)
    // 0 1 1 1 | 0 (from CD=11, AB=01)
    // 1 0 0 0 | 1 (from CD=00, AB=10)
    // 1 0 0 1 | d=1
    // 1 0 1 0 | 1 (from CD=10, AB=10)
    // 1 0 1 1 | 1 (from CD=11, AB=10)
    // 1 1 0 0 | 1 (from CD=00, AB=11)
    // 1 1 0 1 | d=1
    // 1 1 1 0 | 1 (from CD=10, AB=11)
    // 1 1 1 1 | 1 (from CD=11, AB=11)

    // Using sum of products for the 1s:
    // (a=0,b=0,c=1,d=0) + (a=0,b=0,c=1,d=1) + (a=0,b=1,c=0,d=0) + (a=1,b=0,c=0,d=0) + 
    // (a=1,b=0,c=1,d=0) + (a=1,b=0,c=1,d=1) + (a=1,b=1,c=0,d=0) + (a=1,b=1,c=1,d=0) + 
    // (a=1,b=1,c=1,d=1)
    
    // Simplification:
    // out = (a & ~b & ~c & ~d) | (a & ~b & c) | (a & b & ~c & ~d) | (a & b & c) | (b & ~a & ~c & ~d) | (~a & ~b & c)
    // out = a | (b & ~c & ~d) | (~a & ~b & c)
    
    assign out = a | (b & ~c & ~d) | (~a & ~b & c);

endmodule
