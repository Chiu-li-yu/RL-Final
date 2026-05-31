module TopModule (
    input [3:0] x,
    output logic f
);
    // K-map:
    //         x[1]x[2]
    // x[3]x[4]  00  01  11  10
    //       00 | d | 0 | d | d |
    //       01 | 0 | d | 1 | 0 |
    //       11 | 1 | 1 | d | d |
    //       10 | 1 | 1 | 0 | d |
    
    // Assume input x is [x3, x4, x1, x2]
    // Row: x[3], x[4]
    // Col: x[1], x[2]
    
    logic x3, x4, x1, x2;
    assign x3 = x[3];
    assign x4 = x[2];
    assign x1 = x[1];
    assign x2 = x[0];
    
    // Table:
    // R C | F
    // 00 00 | 0
    // 00 01 | 0
    // 00 11 | 0
    // 00 10 | 0
    // 01 00 | 0
    // 01 01 | 1 (d chosen as 1)
    // 01 11 | 1
    // 01 10 | 0
    // 11 00 | 1
    // 11 01 | 1
    // 11 11 | 0 (d chosen as 0)
    // 11 10 | 0 (d chosen as 0)
    // 10 00 | 1
    // 10 01 | 1
    // 10 11 | 0
    // 10 10 | 0 (d chosen as 0)
    
    always @(*) begin
        // Let's implement K-map directly
        // f(x3, x4, x1, x2)
        // Grouping:
        // (x3=1, x4=0, x1=0, x2=0) -> 1
        // (x3=1, x4=0, x1=0, x2=1) -> 1
        // (x3=1, x4=1, x1=0, x2=0) -> 1
        // (x3=1, x4=1, x1=0, x2=1) -> 1
        // (x3=0, x4=1, x1=1, x2=1) -> 1
        // (x3=0, x4=1, x1=0, x2=1) -> 1
        
        // Simplified Logic:
        // f = x3 & ~x1 | ~x3 & x4 & x1
        // Wait, let's re-verify:
        // If x3=1: f = ~x1 (x4, x2 can be anything) -> (1,0,0,0), (1,0,0,1), (1,1,0,0), (1,1,0,1)
        // If x3=0: f = x4 & x1 (x2 can be anything) -> (0,1,1,1), (0,1,1,0)
        
        f = (x3 & ~x1) | (~x3 & x4 & x1);
    end
endmodule
