module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);
    // K-map:
    //      ab
    // cd   00 01 10 11
    // 00 | 0| d| 1| 1|
    // 01 | 0| 0| d| d|
    // 11 | 0| 1| 1| 1|
    // 10 | 0| 1| 1| 1|

    // Truth Table:
    // c d a b | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | d
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | d
    // 0 1 1 1 | d
    // 1 0 0 0 | 0
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    // Let's use Sum of Products from 1s:
    // (0,0,1,0) = ~c ~d a ~b
    // (0,0,1,1) = ~c ~d a b
    // (1,0,0,1) = c ~d ~a b
    // (1,0,1,0) = c ~d a ~b
    // (1,0,1,1) = c ~d a b
    // (1,1,0,1) = c d ~a b
    // (1,1,1,0) = c d a ~b
    // (1,1,1,1) = c d a b

    // Logic:
    // (~c ~d a ~b) | (~c ~d a b) = ~c ~d a
    // (c ~d ~a b) | (c ~d a b) = c ~d b
    // (c d ~a b) | (c d a b) = c d b
    // (c ~d a ~b) | (c d a ~b) = c a ~b
    
    // Simplification attempt: 
    // (~c ~d a) | (c ~d b) | (c d b) | (c a ~b)
    // (~c ~d a) | (c b (~d | d)) | (c a ~b)
    // (~c ~d a) | (c b) | (c a ~b)
    // (~c ~d a) | (c & (b | (a & ~b)))
    // (~c ~d a) | (c & (b | a))
    
    always @(*) begin
        out = (~c & ~d & a) | (c & (b | a));
    end
endmodule
