module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table analysis:
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

    // This is the XOR truth table for 4 inputs:
    // q = ~(a ^ b ^ c ^ d)
    // Let's verify:
    // 0^0^0^0 = 0 -> ~0 = 1 (Correct)
    // 0^0^0^1 = 1 -> ~1 = 0 (Correct)
    // 0^1^1^0 = 0 -> ~0 = 1 (Correct)
    // 1^1^1^1 = 0 -> ~0 = 1 (Correct)

    logic q_val;
    always @(*) begin
        q_val = ~(a ^ b ^ c ^ d);
    end

    assign q = q_val;

endmodule
