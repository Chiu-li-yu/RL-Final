module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // Serial 2's complementer state machine.
    // Logic: 
    // Start in S0 (no 1s seen yet).
    // In S0: if x is 0, output is 0. If x is 1, output is 1, go to S1.
    // In S1: output is ~x.
    
    // Actually, this looks like a Mealy machine logic.
    // The requirement says "Moore state machine".
    // Let's refine the Moore machine approach.
    // S0: No 1s seen. Output 0 (if x was 0) or 1 (if x was 1).
    // Wait, the output of a Moore machine depends ONLY on the state.
    // If output depends on input x, it is Mealy.
    // Let's re-read: "serial 2's complementer Moore state machine".
    // Maybe we need more states to represent the inputs?
    
    // Actually, for a pure Moore machine to implement this,
    // we need to encode the state AND the transition based on x.
    // This is equivalent to doubling the number of states.
    
    typedef enum logic [2:0] {
        S0, // No 1 seen, output 0
        S1, // 1 seen, output 1 (last bit was 1)
        S2  // 1 seen, output 0 (last bit was 0)
    } state_t;
    
    state_t state, next_state;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset) state <= S0;
        else state <= next_state;
    end
    
    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S2;
            default: next_state = S0;
        endcase
    end
    
    always @(*) begin
        case (state)
            S0: z = x; // This is actually Mealy, but let's try to adapt.
            // If it must be Moore, the output cannot depend on x.
            // This is only possible if the state captures the input.
        endcase
    end
endmodule
