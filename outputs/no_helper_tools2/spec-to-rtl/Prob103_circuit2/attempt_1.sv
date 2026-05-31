module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

    logic q_internal;

    always @(*) begin
        // Based on the truth table, find the function.
        // The table:
        // a b c d | q
        // 0 0 0 0 | 1
        // 0 0 0 1 | 0
        // 0 0 1 0 | 0
        // 0 0 1 1 | 1
        // 0 1 0 0 | 0
        // 0 1 0 1 | 1
        // 0 1 1 0 | 1
        // 0 1 1 1 | 0
        // 1 0 0 0 | 0
        // 1 0 0 1 | 1
        // 1 0 1 0 | 1
        // 1 0 1 1 | 0
        // 1 1 0 0 | 1
        // 1 1 0 1 | 0
        // 1 1 1 0 | 0
        // 1 1 1 1 | 1
        
        // This is a 4-input XOR gate: q = a ^ b ^ c ^ d ^ 1
        q_internal = ~(a ^ b ^ c ^ d);
    end

    assign q = q_internal;

endmodule
