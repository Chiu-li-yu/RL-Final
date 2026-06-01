module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // Moore machine: The output is determined by the current state.
    // The previous state is assumed to be 0 (S0).
    
    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7, ERR_STATE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0; // S5 + 0 = discard
            S6: next_state = (in) ? S7 : S0; // S6 + 0 = flag
            S7: next_state = (in) ? ERR_STATE : S0;
            ERR_STATE: next_state = ERR_STATE;
        endcase
    end

    // Moore outputs: depend on state
    // "The output signals should be asserted for a complete cycle beginning on the clock cycle after the condition occurs."
    // If input is 0111110, at the time of 0 (after 5 1s), we are in state S5. 
    // The disc signal needs to be high on the *next* cycle.
    // This is Mealy behavior, but the prompt says "Create a Moore-type FSM".
    // A Moore machine output depends on the state. To get output on the *next* cycle, 
    // we can use a registered output that depends on the state transition.
    
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= 1'b0;
            flag <= 1'b0;
            // err remains high
            
            case (next_state)
                S0: begin
                    if (state == S5 && in == 1'b0) disc <= 1'b1;
                    if (state == S6 && in == 1'b0) flag <= 1'b1;
                end
                ERR_STATE: err <= 1'b1;
                S7: if (state == S7 && in == 1'b1) err <= 1'b1;
            endcase
        end
    end

endmodule