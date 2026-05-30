module TopModule (
    input clk,
    input reset,
    input in,
    output logic out
);
    typedef enum logic {
        STATE_B = 1'b0,
        STATE_A = 1'b1
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            STATE_B: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            STATE_A: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            default: begin
                out = 1'b1;
                next_state = STATE_B;
            end
        endcase
    end
endmodule
