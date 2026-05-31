module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

    // Mealy machine logic for 2's complement:
    // If state = 0 (no 1 yet), z = x. 
    // If we receive a 1, state = 1.
    // If state = 1 (after first 1), z = ~x.
    
    // Actually, serial 2's complement is classically a Mealy machine 
    // where output is function of (state, input).
    
    // State 0: no 1s seen yet.
    // State 1: at least one 1 seen.
    
    logic state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Moore machine output depends only on state.
    // But for 2's complement, z depends on x.
    // So let's fix the transition logic.
    
    // Correct logic:
    // State 0: output 0 (for current bit), next state depends on input x
    // State 1: output 1 (inverted), next state remains 1
    
    // Actually, looking at literature, serial 2's complement:
    // S0: No 1s yet.
    // S1: 1s encountered.
    // Output z:
    // If in S0 and x=0, z=0.
    // If in S0 and x=1, z=1, then go to S1.
    // If in S1, z=~x.

    // This is clearly a Mealy machine. But the prompt asks for Moore.
    // Can we implement Moore? 
    // Yes, with enough states, but let's re-verify the input/output 
    // timing.
    
    // Maybe the output z is registered?
    // Let's try register the output z.

    logic z_reg;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z_reg <= 1'b0;
        end else begin
            if (state == 1'b0) begin
                z_reg <= x;
                state <= (x == 1'b1) ? 1'b1 : 1'b0;
            end else begin
                z_reg <= ~x;
                state <= 1'b1;
            end
        end
    end
    
    assign z = z_reg;

endmodule
