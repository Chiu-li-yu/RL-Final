module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // State definitions
    // IDLE(0), 1s(1), 11s(2), 111s(3), 1111s(4), 11111s(5), 111111s(6), 1111111s(7), ERR
    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7, S_ERR
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S0:    next_state = (in) ? S1 : S0;
            S1:    next_state = (in) ? S2 : S0;
            S2:    next_state = (in) ? S3 : S0;
            S3:    next_state = (in) ? S4 : S0;
            S4:    next_state = (in) ? S5 : S0;
            S5:    next_state = (in) ? S6 : S0; // S5 + in=0 -> disc
            S6:    next_state = (in) ? S7 : S0; // S6 + in=0 -> flag
            S7:    next_state = (in) ? S_ERR : S0;
            S_ERR: next_state = S_ERR;
        endcase
    end

    // The output should be asserted for a complete cycle *beginning on the clock cycle after the condition occurs*.
    // This implies we need registers for the outputs that are updated based on the state transition.
    
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
            
            // The condition (e.g. 0111110) happens on the transition to S0 from S5 (if in=0)
            if (state == S5 && in == 1'b0) disc <= 1'b1;
            else if (state == S6 && in == 1'b0) flag <= 1'b1;
            else if (state == S7 && in == 1'b1) err <= 1'b1;
            else if (state == S_ERR) err <= 1'b1;
        end
    end

endmodule