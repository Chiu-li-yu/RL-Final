module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7_ERR
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S5; // 5 ones. if next is 0 (S0), discard. if next is 1, flag.
            S6: next_state = in ? S7_ERR : S0; // 6 ones. if next is 0 (S0), flag. if next is 1, err.
            S7_ERR: next_state = in ? S7_ERR : S0;
            default: next_state = S0;
        endcase
    end

    // Outputs logic: Moore state machine, outputs triggered on next clock
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
                S7_ERR: begin
                    if (current_state == S6 && in) err <= 1'b1;
                    if (current_state == S7_ERR) err <= 1'b1;
                end
            endcase
        end
    end

endmodule