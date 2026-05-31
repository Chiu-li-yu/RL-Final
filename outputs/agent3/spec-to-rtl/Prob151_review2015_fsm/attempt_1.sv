module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    typedef enum logic [3:0] {
        S_IDLE, S_S1, S_S11, S_S110, S_SHIFT, S_COUNT, S_DONE
    } state_t;

    logic [3:0] state, next_state;
    logic [2:0] shift_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT)
                shift_cnt <= shift_cnt + 1'b1;
            else
                shift_cnt <= 3'd0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE:  next_state = (data) ? S_S1 : S_IDLE;
            S_S1:    next_state = (data) ? S_S11 : S_IDLE;
            S_S11:   next_state = (!data) ? S_S110 : S_S11;
            S_S110:  next_state = (data) ? S_SHIFT : S_IDLE;
            S_SHIFT: next_state = (shift_cnt == 3'd3) ? S_COUNT : S_SHIFT;
            S_COUNT: next_state = (done_counting) ? S_DONE : S_COUNT;
            S_DONE:  next_state = (ack) ? S_IDLE : S_DONE;
            default: next_state = S_IDLE;
        endcase
    end

    assign shift_ena = (state == S_SHIFT);
    assign counting = (state == S_COUNT);
    assign done = (state == S_DONE);

endmodule