module TopModule(
    input clk,
    input reset,
    output logic shift_ena
);

    // FSM State definition
    typedef enum logic [2:0] {
        S_COUNT_0 = 3'd0,
        S_COUNT_1 = 3'd1,
        S_COUNT_2 = 3'd2,
        S_COUNT_3 = 3'd3,
        S_IDLE    = 3'd4
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            S_COUNT_0: next_state = S_COUNT_1;
            S_COUNT_1: next_state = S_COUNT_2;
            S_COUNT_2: next_state = S_COUNT_3;
            S_COUNT_3: next_state = S_IDLE;
            default:   next_state = S_IDLE;
        endcase
    end

    // Sequential logic for state and reset
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S_COUNT_0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        case (current_state)
            S_COUNT_0, S_COUNT_1, S_COUNT_2, S_COUNT_3: shift_ena = 1'b1;
            default: shift_ena = 1'b0;
        endcase
    end

endmodule
