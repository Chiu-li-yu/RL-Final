module TopModule(
    input clk,
    input reset,
    input data,
    output logic start_shifting
);

    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S11  = 3'd2,
        S110 = 3'd3,
        DONE = 3'd4
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S11 : IDLE;
            S11:  next_state = data ? S11 : S110;
            S110: next_state = data ? DONE : IDLE;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        start_shifting = (state == DONE);
    end

endmodule
