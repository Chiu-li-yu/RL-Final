module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map Analysis:
    // a b | 00 01 11 10
    // c d |
    // ----|-----------
    // 00  | 0  1  0  1
    // 01  | 1  0  1  0
    // 11  | 0  1  0  1
    // 10  | 1  0  1  0
    
    // Observed pattern: 
    // out = 1 when (a=0,b=1) OR (a=1,b=0) AND (c=0,d=0) OR (c=1,d=1) ...
    // Let's simplify:
    // Out is 1 when:
    // (a=0, b=1, c=0, d=0) -> ~a & b & ~c & ~d
    // (a=0, b=1, c=1, d=1) -> ~a & b & c & d
    // (a=1, b=0, c=0, d=0) -> a & ~b & ~c & ~d
    // (a=1, b=0, c=1, d=1) -> a & ~b & c & d
    
    // Combining terms:
    // out = (~a & b & (~c & ~d | c & d)) | (a & ~b & (~c & ~d | c & d))
    // out = (~a & b | a & ~b) & (~c & ~d | c & d)
    // out = (a ^ b) & ~(c ^ d)

    assign out = (a ^ b) & ~(c ^ d);

endmodule
