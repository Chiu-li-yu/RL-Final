module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    typedef enum logic {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            STATE_B: begin
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            STATE_A: begin
                if (in == 1'b0)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            default: next_state = STATE_B;
        endcase
    end

    assign out = (current_state == STATE_B) ? 1'b1 : 1'b0;

endmodule
