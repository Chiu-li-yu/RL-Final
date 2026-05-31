module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // K-map:
    //    cd \ ab  00  01  10  11
    //    00       0   d   1   1
    //    01       0   0   d   d
    //    11       1   0   1   1
    //    10       1   0   1   1
    
    // Let's interpret 'd' as don't-care:
    // (a=0, b=0, c=0, d=0) -> 0
    // (a=0, b=1, c=0, d=0) -> d (don't care) -> set 0
    // (a=1, b=0, c=0, d=0) -> 1
    // (a=1, b=1, c=0, d=0) -> 1
    
    // (a=0, b=0, c=0, d=1) -> 0
    // (a=0, b=1, c=0, d=1) -> 0
    // (a=1, b=0, c=0, d=1) -> d -> set 1
    // (a=1, b=1, c=0, d=1) -> d -> set 1
    
    // (a=0, b=0, c=1, d=1) -> 1
    // (a=0, b=1, c=1, d=1) -> 0
    // (a=1, b=0, c=1, d=1) -> 1
    // (a=1, b=1, c=1, d=1) -> 1
    
    // (a=0, b=0, c=1, d=0) -> 1
    // (a=0, b=1, c=1, d=0) -> 0
    // (a=1, b=0, c=1, d=0) -> 1
    // (a=1, b=1, c=1, d=0) -> 1
    
    // Truth table:
    // a b c d | out
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 1
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 0
    // 0 1 1 0 | 0
    // 0 1 1 1 | 0
    // 1 0 0 0 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 1
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1
    
    // Simplify:
    // If a=1, out=1
    // If a=0, out=1 only if c=1 and b=0
    // So: out = a | (~b & c)
    
    always @(*) begin
        out = a | (~b & c);
    end

endmodule
