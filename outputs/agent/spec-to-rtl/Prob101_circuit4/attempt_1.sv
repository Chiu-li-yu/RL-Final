module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    logic q_val;
    assign q = q_val;

    always @(*) begin
        // Mapping based on the truth table:
        // a b c d | q
        // 0 0 0 0 | 0
        // 0 0 0 1 | 0
        // 0 0 1 0 | 1
        // 0 0 1 1 | 1
        // 0 1 0 0 | 1
        // 0 1 0 1 | 1
        // 0 1 1 0 | 1
        // 0 1 1 1 | 1
        // 1 0 0 0 | 0
        // 1 0 0 1 | 0
        // 1 0 1 0 | 1
        // 1 0 1 1 | 1
        // 1 1 0 0 | 1
        // 1 1 0 1 | 1
        // 1 1 1 0 | 1
        // 1 1 1 1 | 1
        
        // Simplified Logic:
        // The output is 0 only when:
        // (a=0, b=0, c=0, d=0) -> 0
        // (a=0, b=0, c=0, d=1) -> 0
        // (a=1, b=0, c=0, d=0) -> 0
        // (a=1, b=0, c=0, d=1) -> 0
        // Basically, if (b == 0 && c == 0), then q = 0, otherwise 1?
        // Wait, check:
        // if b=0, c=0:
        // a=0, d=0 -> q=0
        // a=0, d=1 -> q=0
        // a=1, d=0 -> q=0
        // a=1, d=1 -> q=0
        // Seems correct.
        
        if (b == 0 && c == 0)
            q_val = 0;
        else
            q_val = 1;
    end
endmodule
