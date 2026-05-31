module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh Map:
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
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    logic out_val;
    always @(*) begin
        // K-Map sum of products
        // (a=0,b=0) -> c=0,d=0 (1); c=0,d=1 (1); c=1,d=0 (1); c=1,d=1 (0) -> (~a & ~b & ~c) | (~a & ~b & ~d)
        // (a=0,b=1) -> c=0,d=0 (1); c=0,d=1 (0); c=1,d=0 (1); c=1,d=1 (1) -> (~a & b & ~c & ~d) | (~a & b & c)
        // (a=1,b=0) -> c=0,d=0 (1); c=0,d=1 (1); c=1,d=0 (0); c=1,d=1 (1) -> (a & ~b & ~c) | (a & ~b & c & d)
        // (a=1,b=1) -> c=0,d=0 (0); c=0,d=1 (0); c=1,d=0 (1); c=1,d=1 (1) -> (a & b & c)
        
        out_val = (~a & ~b & ~c) | (~a & ~b & ~d) | 
                  (~a & b & ~c & ~d) | (~a & b & c) | 
                  (a & ~b & ~c) | (a & ~b & c & d) | 
                  (a & b & c);
    end
    assign out = out_val;
endmodule
