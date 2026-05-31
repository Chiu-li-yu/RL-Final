module TopModule (
    input clk,
    input reset,
    input data,
    output logic start_shifting
);

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        S1    = 3'd1,
        S11   = 3'd2,
        S110  = 3'd3,
        FOUND = 3'd4
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else if (current_state == FOUND) begin
            start_shifting <= 1'b1;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:  next_state = data ? S1 : IDLE;
            S1:    next_state = data ? S11 : IDLE;
            S11:   next_state = data ? S11 : S110;
            S110:  next_state = data ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

endmodule
