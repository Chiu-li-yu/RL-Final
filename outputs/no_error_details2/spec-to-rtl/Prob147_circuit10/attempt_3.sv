module TopModule(
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // Re-evaluating the truth table from trace
    // Time 45: clk rising, a=0, b=1, state=0 -> q=1, state=0
    // Time 75: clk rising, a=0, b=0, state=0 -> q=1, state=1
    // Time 85: clk rising, a=1, b=1, state=1 -> q=0, state=0
    
    // Let's re-verify:
    // (state, a, b) -> (next_state, q)
    // (0, 0, 0) -> (1, 0)? No, at 15ns, state=0, a=0, b=0 -> q=0, next_state=0?
    // Trace says:
    // 10ns: state=?, a=0, b=0
    // 15ns: state=0, q=0
    // 20ns: state=0, q=0
    // ...
    // 40ns: state=0, a=0, b=0
    // 45ns: clk posedge, a=0, b=1, state=0 -> q=1
    // 55ns: clk posedge, a=1, b=0, state=0 -> q=1
    // 65ns: clk posedge, a=1, b=1, state=0 -> q=0, state becomes 0
    // 75ns: clk posedge, a=0, b=0, state=1 -> q=1, state becomes 1... wait
    
    // Maybe state is updated with a clock enable?
    // Let's try:
    // next_state = (state & ~a & ~b) | (~state & a & b)
    // q = (state & ~a & ~b) | (~state & a & ~b) | (~state & ~a & b)
    
    logic next_state;
    always_ff @(posedge clk) begin
        state <= next_state;
    end
    
    always_comb begin
        // Based on observing the transitions
        // state=0:
        //  a=0,b=0 -> q=0, ns=0
        //  a=0,b=1 -> q=1, ns=0
        //  a=1,b=0 -> q=1, ns=0
        //  a=1,b=1 -> q=0, ns=1
        // state=1:
        //  a=0,b=0 -> q=1, ns=1
        //  a=0,b=1 -> q=0, ns=1
        //  a=1,b=0 -> q=0, ns=1
        //  a=1,b=1 -> q=1, ns=0
        
        // This looks like:
        // q = state ^ a ^ b
        // next_state = (state & ~(a&b)) | (~state & a&b) = state ^ (a&b) -- Wait, same as before?
        // Let's re-check (1,1,1) -> 0. state=1, a=1, b=1 -> next_state = 1^(1&1) = 0. (Correct)
        // (1,0,0) -> 1. state=1, a=0, b=0 -> next_state = 1^(0&0) = 1. (Correct)
        // (0,1,1) -> 1. state=0, a=1, b=1 -> next_state = 0^(1&1) = 1. (Correct)
        
        // It *must* be the reset value. What if state starts at 0?
        // 10ns: state=? (x). If reset is not specified, maybe it defaults to 0?
        // Let's force reset to 0.
        
        // Try state reset to 0 explicitly.
        
    end
    
    initial state = 0;
    
    always_ff @(posedge clk) begin
        state <= state ^ (a & b);
    end
    assign q = state ^ a ^ b;
endmodule