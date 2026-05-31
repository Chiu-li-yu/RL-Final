module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7, DISC_S, FLAG_S, ERR_S
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : DISC_S;
            S6: next_state = in ? S7 : FLAG_S;
            S7: next_state = in ? S7 : ERR_S; // 7+ ones
            DISC_S: next_state = in ? S1 : S0;
            FLAG_S: next_state = in ? S1 : S0;
            ERR_S: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    always_comb begin
        disc = (state == DISC_S);
        flag = (state == FLAG_S);
        err  = (state == S7 || state == ERR_S);
    end

endmodule
