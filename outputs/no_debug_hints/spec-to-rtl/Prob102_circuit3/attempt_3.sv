module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output logic q
);
    // Truth table analysis:
    // a b c d | q
    // 0 0 0 0 | 0
    // 0 0 0 1 | 0
    // 0 0 1 0 | 0
    // 0 0 1 1 | 0
    // 0 1 0 0 | 0
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 0 | 0
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 0 | 0
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    // Look at cases where q=1:
    // 0101, 0110, 0111
    // 1001, 1010, 1011
    // 1101, 1110, 1111

    // Grouping by a,b:
    // If a=0, b=1: q=1 if (c=0, d=1) OR (c=1, d=0) OR (c=1, d=1)
    // -> q = c | d (when a=0, b=1)
    
    // If a=1, b=0: q=1 if (c=0, d=1) OR (c=1, d=0) OR (c=1, d=1)
    // -> q = c | d (when a=1, b=0)
    
    // If a=1, b=1: q=1 if (c=0, d=1) OR (c=1, d=0) OR (c=1, d=1)
    // -> q = c | d (when a=1, b=1)

    // So q = (a|b) & (c|d)
    
    always @(*) begin
        q = (a | b) & (c | d);
    end
endmodule
