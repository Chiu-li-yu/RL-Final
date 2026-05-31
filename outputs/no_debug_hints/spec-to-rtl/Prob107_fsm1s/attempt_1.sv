module TopModule(
    input clk,
    input reset,
    input in,
    output logic out
);

    typedef enum logic {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_B: begin
                if (in == 1'b0) next_state = STATE_A;
                else next_state = STATE_B;
            end
            STATE_A: begin
                if (in == 1'b0) next_state = STATE_B;
                else next_state = STATE_A;
            end
            default: next_state = STATE_B;
        endcase
    end

    // Output logic
    always @(*) begin
        if (current_state == STATE_B)
            out = 1'b1;
        else
            out = 1'b0;
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_B;
        else
            current_state <= next_state;
    end

endmodule
