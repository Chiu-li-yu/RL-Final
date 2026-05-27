module TopModule (
    input logic a,
    input logic b,
    input logic c,
    output logic out
);

    always @(*) begin
        // K-map analysis:
        // BC\A | 0 | 1
        // -----|---|---
        // 00   | 0 | 1
        // 01   | 1 | 1
        // 11   | 1 | 1
        // 10   | 1 | 1
        
        // Logical expression from K-map:
        // The ones are at:
        // (a=0,b=0,c=1) -> a'b'c
        // (a=0,b=1,c=1) -> a'bc
        // (a=0,b=1,c=0) -> a'bc'
        // (a=1,b=0,c=0) -> ab'c'
        // (a=1,b=0,c=1) -> ab'c
        // (a=1,b=1,c=0) -> abc'
        // (a=1,b=1,c=1) -> abc
        
        // Simplified:
        // The only zero is at (a=0, b=0, c=0).
        // So out = a | b | c
        
        out = a | b | c;
    end

endmodule
