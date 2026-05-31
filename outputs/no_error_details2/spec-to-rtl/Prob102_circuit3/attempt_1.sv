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
        // Analying the truth table:
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
        
        // q is 1 if (a | b) is 1 AND (c | d) is 1
        q_val = (a | b) & (c | d);
    end
endmodule
