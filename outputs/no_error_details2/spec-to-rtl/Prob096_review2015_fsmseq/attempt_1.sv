module TopModule (
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

    logic [2:0] state, next_state;

    always_ff @(posedge clk) begin
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

    always_ff @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else if (next_state == DONE) begin
            start_shifting <= 1'b1;
        end
    end

endmodule
