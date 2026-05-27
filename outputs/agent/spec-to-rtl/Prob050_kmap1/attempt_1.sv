module TopModule (
    input logic a,
    input logic b,
    input logic c,
    output logic out
);

    always @(*) begin
        // K-map analysis:
        // bc \ a | 0 | 1
        // -------+---+---
        // 00     | 0 | 1
        // 01     | 1 | 1
        // 11     | 1 | 1
        // 10     | 1 | 1
        
        // Sum of products (1s):
        // (a=0, b=0, c=1) -> ~a & ~b & c
        // (a=0, b=1, c=1) -> ~a & b & c
        // (a=0, b=1, c=0) -> ~a & b & ~c
        // (a=1, b=0, c=0) -> a & ~b & ~c
        // (a=1, b=0, c=1) -> a & ~b & c
        // (a=1, b=1, c=0) -> a & b & ~c
        // (a=1, b=1, c=1) -> a & b & c
        
        // Simplified Logic:
        // out = a | (b & ~c) | (~b & c) | (b & c)
        // Let's re-verify the map:
        // 000: 0
        // 001: 1
        // 010: 1
        // 011: 1
        // 100: 1
        // 101: 1
        // 110: 1
        // 111: 1
        
        // Looking at the K-map: 
        // 0 at 000. All other 7 combinations are 1.
        // Therefore, out is 1 unless a=0, b=0, and c=0.
        // out = !(~a & ~b & ~c) = a | b | c
        
        out = a | b | c;
    end

endmodule
