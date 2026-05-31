module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);
    // Pattern detector: 1101
    // The FSM needs to shift in 4 bits AFTER detecting 1101
    typedef enum logic [3:0] {
        S_IDLE, S_1, S_11, S_110, S_1101, S_SHIFT, S_COUNT, S_DONE
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_cnt;

    always_ff @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always_ff @(posedge clk) begin
        if (reset) shift_cnt <= 3'd0;
        else if (state == S_SHIFT) shift_cnt <= shift_cnt + 1'b1;
        else shift_cnt <= 3'd0;
    end

    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            S_IDLE: next_state = (data) ? S_1 : S_IDLE;
            S_1:    next_state = (data) ? S_11 : S_IDLE;
            S_11:   next_state = (data) ? S_11 : S_110;
            S_110:  next_state = (data) ? S_1101 : S_IDLE;
            S_1101: next_state = S_SHIFT;
            S_SHIFT: begin
                shift_ena = 1'b1;
                if (shift_cnt == 3'd3) next_state = S_COUNT;
            end
            S_COUNT: begin
                counting = 1'b1;
                if (done_counting) next_state = S_DONE;
            end
            S_DONE: begin
                done = 1'b1;
                if (ack) next_state = S_IDLE;
                else next_state = S_DONE;
            end
            default: next_state = S_IDLE;
        endcase
    end
endmodule