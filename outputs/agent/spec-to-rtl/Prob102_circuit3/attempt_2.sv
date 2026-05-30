module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Let's re-examine the truth table carefully.
    // a b c d | q
    // 0 0 0 0 | 0
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 1
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 1
    // 1 1 0 1 | 1
    // 1 1 1 0 | 1
    // 1 1 1 1 | 1

    // It looks like q = 1 if (a OR b) AND (c OR d)?
    // Test:
    // (0 1) & (0 1) -> 1 & 1 = 1 (Time 40) - OK
    // (0 1) & (1 0) -> 1 & 1 = 1 (Time 45) - OK
    // (0 1) & (1 1) -> 1 & 1 = 1 (Time 50) - OK
    // (1 0) & (0 1) -> 1 & 1 = 1 (Time 60) - OK
    // (1 0) & (1 0) -> 1 & 1 = 1 (Time 65) - OK
    // (1 1) & (0 1) -> 1 & 1 = 1 (Time 80) - OK
    // (1 1) & (1 0) -> 1 & 1 = 1 (Time 85) - OK
    // (0 0) & (0 0) -> 0 & 0 = 0 (Time 0) - OK
    
    logic q_val;
    always @(*) begin
        q_val = (a | b) & (c | d);
    end
    
    assign q = q_val;
endmodule
