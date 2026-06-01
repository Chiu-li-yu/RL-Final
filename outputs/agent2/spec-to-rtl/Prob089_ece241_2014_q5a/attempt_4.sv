module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // Let's use simple states and implement it correctly.
    // Standard serial 2's complementer is often implemented as a Mealy machine.
    // If the problem strictly demands Moore, I need to split the states.
    // However, many "Moore" FSM problems actually allow Mealy-like 
    // structures if the state transitions correctly.
    // Let's go back to the simplest working logic:
    
    logic state, next_state;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset) state <= 1'b0;
        else state <= next_state;
    end
    
    always @(*) begin
        case (state)
            1'b0: next_state = (x) ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end
    
    // In a pure Moore machine, z = f(state).
    // If we use current state AND input to decide next state,
    // we can make the output depend only on the current state.
    // Let's define states:
    // S0: No 1 seen. 
    // S1: First 1 just seen (output 1).
    // S2: After first 1 (output 0).
    // S3: After first 1 (output 1).
    
    typedef enum logic [1:0] {S0=0, S1=1, S2=2, S3=3} state_t;
    state_t curr, next;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset) curr <= S0;
        else curr <= next;
    end
    
    always @(*) begin
        case(curr)
            S0: next = x ? S1 : S0;
            S1: next = x ? S3 : S2;
            S2: next = x ? S3 : S2;
            S3: next = x ? S3 : S2;
            default: next = S0;
        endcase
    end
    
    always @(*) begin
        case(curr)
            S0: z = x; // Wait, this still depends on x.
            // A pure Moore machine cannot output z = x.
            // Maybe the state IS the answer?
        endcase
    end
endmodule
