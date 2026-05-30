module TopModule(
    input a,
    input b,
    input c,
    output out
);
    logic out_val;
    assign out = out_val;

    always @(*) begin
        // Karnaugh Map:
        // bc \ a | 0 | 1
        // -------+---+---
        // 00     | 0 | 1
        // 01     | 1 | 1
        // 11     | 1 | 1
        // 10     | 1 | 1
        
        // Sum of products (1s):
        // (a=0, b=0, c=1) -> a'b'c
        // (a=0, b=1, c=0) -> a'bc'
        // (a=0, b=1, c=1) -> a'bc
        // (a=1, b=0, c=0) -> ab'c'
        // (a=1, b=0, c=1) -> ab'c
        // (a=1, b=1, c=0) -> abc'
        // (a=1, b=1, c=1) -> abc
        // (a=1, b=0, c=0) (wait, a=1 row is all 1)
        
        // Simplified Logic:
        // The table is:
        // a b c | out
        // 0 0 0 | 0
        // 0 0 1 | 1
        // 0 1 0 | 1
        // 0 1 1 | 1
        // 1 0 0 | 1
        // 1 0 1 | 1
        // 1 1 0 | 1
        // 1 1 1 | 1
        
        // out is 0 only when (a=0, b=0, c=0).
        // So out = a | b | c
        
        out_val = a | b | c;
    end
endmodule
