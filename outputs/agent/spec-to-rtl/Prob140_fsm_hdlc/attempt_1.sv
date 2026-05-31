module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7, S_ERR
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0; // 5 consecutive 1s detected
            S6: next_state = (in) ? S7 : S0; // 6 consecutive 1s detected
            S7: next_state = (in) ? S_ERR : S0; // 7+ consecutive 1s
            S_ERR: next_state = S_ERR;
            default: next_state = S0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
            
            case (next_state)
                S0: begin
                    if (current_state == S5 && !in) disc <= 1'b1;
                    if (current_state == S6 && !in) flag <= 1'b1;
                end
                S_ERR: err <= 1'b1;
            endcase
        end
    end

endmodule