module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7, S8
    } state_t;

    state_t state, next_state;

    // FSM Logic
    always_ff @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0; // 5 consecutive 1s
            S6: next_state = (in) ? S7 : S8; // 6 consecutive 1s
            S7: next_state = (in) ? S7 : S8; // 7+ consecutive 1s
            S8: next_state = (in) ? S1 : S0; // Found 0, reset counter logic
            default: next_state = S0;
        endcase
    end

    // Moore Outputs
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err  <= 0;
        end else begin
            disc <= (next_state == S8 && state == S5);
            flag <= (next_state == S8 && state == S6);
            err  <= (next_state == S7);
        end
    end

endmodule
