module TopModule (
    input clk,
    input reset,
    input data,
    output logic start_shifting
);

    typedef enum logic [2:0] {
        IDLE    = 3'd0,
        S1      = 3'd1,
        S11     = 3'd2,
        S110    = 3'd3,
        FOUND   = 3'd4
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == FOUND) begin
                start_shifting <= 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data) next_state = S1;
                else      next_state = IDLE;
            end
            S1: begin
                if (data) next_state = S11;
                else      next_state = IDLE;
            end
            S11: begin
                if (!data) next_state = S110;
                else       next_state = S11;
            end
            S110: begin
                if (data) next_state = FOUND;
                else      next_state = IDLE;
            end
            FOUND: begin
                next_state = FOUND;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
