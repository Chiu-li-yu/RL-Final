module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table analysis:
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

    // Looking at the patterns:
    // q = 1 when c is 1 (c=1 -> q=1)
    // OR
    // q = 1 when b is 1 (b=1 -> q=1)
    // So if b=1 or c=1, q=1.
    // Let's check:
    // If b=1 or c=1:
    // 0000 -> 0 (correct)
    // 0001 -> 0 (correct)
    // 0010 -> 1 (correct)
    // 0011 -> 1 (correct)
    // 0100 -> 1 (correct)
    // ...
    // Yes, the logic simplifies to q = b | c.

    logic q_int;
    always @(*) begin
        q_int = b | c;
    end
    assign q = q_int;

endmodule