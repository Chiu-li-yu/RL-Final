module TopModule (
    input logic clk,
    input logic areset,
    input logic in,
    output logic out
);

    typedef enum logic {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    state_t state, next_state;

    // Moore machine output depends only on state
    always @(*) begin
        out = (state == STATE_A) ? 1'b0 : 1'b1;
    end

    // Next state logic
    always @(*) begin
        case (state)
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

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_B;
        else
            state <= next_state;
    end

endmodule
