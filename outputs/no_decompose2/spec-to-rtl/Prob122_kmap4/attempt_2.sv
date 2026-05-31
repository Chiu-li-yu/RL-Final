module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    logic out_val;
    assign out = out_val;

    always @(*) begin
        // Let's re-verify the K-map carefully:
        //      ab=00  01  11  10
        // cd=00 | 0 | 1 | 0 | 1 |
        // cd=01 | 1 | 0 | 1 | 0 |
        // cd=11 | 0 | 1 | 0 | 1 |
        // cd=10 | 1 | 0 | 1 | 0 |
        
        // This is XOR of b and d?
        // (b,d) -> out
        // 0,0 -> (00,00)=0, (00,10)=1? No.
        
        // Check b ^ d:
        // (b,d) -> out
        // (00, 00) b=0, d=0 -> 0
        // (00, 01) b=0, d=1 -> 1
        // (00, 11) b=0, d=1 -> 1. Wait, Map says 0.
        
        // Let's analyze bit by bit:
        // 1s at:
        // (cd, ab)
        // (00, 01)
        // (00, 10)
        // (01, 00)
        // (01, 11)
        // (11, 01)
        // (11, 10)
        // (10, 00)
        // (10, 11)
        
        // Pattern: out = (a ^ b) ^ (c ^ d) ?
        // (0,0,0,0) -> 0
        // (0,0,0,1) -> 1
        // (0,0,1,0) -> 1
        // (0,0,1,1) -> 0
        // (0,1,0,0) -> 1
        // (0,1,0,1) -> 0
        // (0,1,1,0) -> 0
        // (0,1,1,1) -> 1
        // Matches?
        // (0,0,0,1) -> a=0,b=0,c=0,d=1. Map: ab=00, cd=01. Value=1. Correct.
        // (0,0,1,0) -> a=0,b=0,c=1,d=0. Map: ab=00, cd=10. Value=1. Correct.
        // (0,0,1,1) -> a=0,b=0,c=1,d=1. Map: ab=00, cd=11. Value=0. Correct.
        // (0,1,0,0) -> a=0,b=1,c=0,d=0. Map: ab=01, cd=00. Value=1. Correct.
        
        out_val = a ^ b ^ c ^ d;
    end

endmodule
