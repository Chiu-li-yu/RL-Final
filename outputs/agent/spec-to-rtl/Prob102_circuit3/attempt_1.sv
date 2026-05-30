module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Looking at the truth table:
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

    // Analyzing when q=1:
    // It seems q = d AND (b OR a) AND (b OR c OR a)? 
    // Wait, let's look at the conditions:
    // If d=0, q=0.
    // If d=1:
    //   a=0, b=0 -> q=0
    //   a=0, b=1 -> q=1
    //   a=1, b=0 -> q=1
    //   a=1, b=1 -> q=1
    // So if d=1, q = a OR b?
    // Let's check:
    // 0 1 0 1 | 1 (a=0, b=1, d=1 -> 0 OR 1 = 1) - Correct
    // 1 0 0 1 | 1 (a=1, b=0, d=1 -> 1 OR 0 = 1) - Correct
    // 1 1 0 1 | 1 (a=1, b=1, d=1 -> 1 OR 1 = 1) - Correct
    // 0 0 0 1 | 0 (a=0, b=0, d=1 -> 0 OR 0 = 0) - Correct
    // The c input doesn't seem to affect q at all in the provided table.
    
    logic q_val;
    always @(*) begin
        q_val = (a | b) & d;
    end
    
    assign q = q_val;
endmodule
