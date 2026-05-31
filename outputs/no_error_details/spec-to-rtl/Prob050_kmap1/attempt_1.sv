module TopModule (
    input a,
    input b,
    input c,
    output out
);
    always @(*) begin
        // K-map Analysis:
        // bc \ a | 0 | 1
        // 00     | 0 | 1
        // 01     | 1 | 1
        // 11     | 1 | 1
        // 10     | 1 | 1
        //
        // Minterms for output=1:
        // (a=0, b=0, c=1) -> 1
        // (a=0, b=1, c=1) -> 1
        // (a=0, b=1, c=0) -> 1
        // (a=1, b=0, c=0) -> 1
        // (a=1, b=0, c=1) -> 1
        // (a=1, b=1, c=0) -> 1
        // (a=1, b=1, c=1) -> 1
        
        // Simplified Logic:
        // out = a + b + c
        // Let's verify:
        // a=0, b=0, c=0 -> 0 (Correct)
        // a=0, b=0, c=1 -> 1 (Correct)
        // a=0, b=1, c=0 -> 1 (Correct)
        // a=0, b=1, c=1 -> 1 (Correct)
        // a=1, b=0, c=0 -> 1 (Correct)
        // a=1, b=0, c=1 -> 1 (Correct)
        // a=1, b=1, c=0 -> 1 (Correct)
        // a=1, b=1, c=1 -> 1 (Correct)
        
        assign out = a | b | c;
    end
endmodule
