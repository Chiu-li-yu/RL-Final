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

    typedef enum logic [3:0] {
        IDLE, S1, S11, S110,
        SHIFT,
        WAIT_COUNT,
        DONE_STATE
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_cnt <= shift_cnt + 1'b1;
            else
                shift_cnt <= 3'd0;
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (data) next_state = S1;
            end
            S1: begin
                if (data) next_state = S11;
                else next_state = IDLE;
            end
            S11: begin
                if (!data) next_state = S110;
            end
            S110: begin
                if (data) next_state = SHIFT;
                else next_state = IDLE;
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_cnt == 3'd3) next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                counting = 1'b1;
                if (done_counting) next_state = DONE_STATE;
            end
            DONE_STATE: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
        endcase
    end

endmodule