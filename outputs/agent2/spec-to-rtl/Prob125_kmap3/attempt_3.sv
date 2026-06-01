module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);
    // Re-evaluating K-map
    //      ab
    // cd  00 01 10 11
    // 00  0  d  1  1
    // 01  0  0  d  d
    // 11  0  1  1  1
    // 10  0  1  1  1

    // Map:
    // (c,d,a,b) = (0,0,0,0) -> 0
    // (c,d,a,b) = (0,0,0,1) -> d
    // (c,d,a,b) = (0,0,1,0) -> 1
    // (c,d,a,b) = (0,0,1,1) -> 1
    // (c,d,a,b) = (0,1,0,0) -> 0
    // (c,d,a,b) = (0,1,0,1) -> 0
    // (c,d,a,b) = (0,1,1,0) -> d
    // (c,d,a,b) = (0,1,1,1) -> d
    // (c,d,a,b) = (1,1,0,0) -> 0
    // (c,d,a,b) = (1,1,0,1) -> 1
    // (c,d,a,b) = (1,1,1,0) -> 1
    // (c,d,a,b) = (1,1,1,1) -> 1
    // (c,d,a,b) = (1,0,0,0) -> 0
    // (c,d,a,b) = (1,0,0,1) -> 1
    // (c,d,a,b) = (1,0,1,0) -> 1
    // (c,d,a,b) = (1,0,1,1) -> 1

    // Let's use truth table logic:
    // out = 1 if:
    // (c=0, d=0, a=1)
    // (c=1, d=1, b=1)
    // (c=1, d=0, b=1)
    
    // Simplification:
    // out = (a & ~c & ~d) | (b & c) | (b & ~d)
    // out = (a & ~c & ~d) | (b & (c | ~d))
    
    always @(*) begin
        out = (a & ~c & ~d) | (b & (c | ~d));
    end
endmodule
