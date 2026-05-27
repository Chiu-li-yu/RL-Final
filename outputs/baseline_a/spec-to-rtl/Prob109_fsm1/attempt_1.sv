module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    typedef enum logic {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Moore machine output depends only on the current state
    assign out = (current_state == STATE_A) ? 1'b0 : 1'b1;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (in == 1'b0)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            default: next_state = STATE_B;
        endcase
    end

    // Sequential logic for state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= STATE_B;
        else
            current_state <= next_state;
    end

endmodule
