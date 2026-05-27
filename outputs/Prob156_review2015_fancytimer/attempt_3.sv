module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

    typedef enum logic [3:0] {
        IDLE,
        MATCH1,
        MATCH11,
        MATCH110,
        SHIFT_DELAY,
        COUNTING,
        WAIT_ACK
    } state_t;

    state_t state, next_state;
    logic [3:0] delay_val, next_delay_val;
    logic [2:0] shift_cnt, next_shift_cnt;
    logic [13:0] cycle_cnt, next_cycle_cnt;
    logic [3:0] current_timer, next_current_timer;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_val <= 4'd0;
            shift_cnt <= 3'd0;
            cycle_cnt <= 14'd0;
            current_timer <= 4'd0;
        end else begin
            state <= next_state;
            delay_val <= next_delay_val;
            shift_cnt <= next_shift_cnt;
            cycle_cnt <= next_cycle_cnt;
            current_timer <= next_current_timer;
        end
    end

    always @(*) begin
        next_state = state;
        next_delay_val = delay_val;
        next_shift_cnt = shift_cnt;
        next_cycle_cnt = cycle_cnt;
        next_current_timer = current_timer;
        counting = 1'b0;
        done = 1'b0;
        count = current_timer;

        case (state)
            IDLE: begin
                if (data) next_state = MATCH1;
            end
            MATCH1: begin
                if (data) next_state = MATCH11;
                else next_state = IDLE;
            end
            MATCH11: begin
                if (!data) next_state = MATCH110;
                else next_state = MATCH11;
            end
            MATCH110: begin
                if (data) begin
                    next_state = SHIFT_DELAY;
                    next_shift_cnt = 3'd0;
                    next_delay_val = 4'd0;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT_DELAY: begin
                next_delay_val = {delay_val[2:0], data};
                if (shift_cnt == 3'd3) begin
                    next_state = COUNTING;
                    next_current_timer = {delay_val[2:0], data};
                    next_cycle_cnt = 14'd999;
                end else begin
                    next_shift_cnt = shift_cnt + 1'b1;
                end
            end
            COUNTING: begin
                counting = 1'b1;
                if (cycle_cnt == 14'd0) begin
                    if (current_timer == 4'd0) begin
                        next_state = WAIT_ACK;
                    end else begin
                        next_current_timer = current_timer - 1'b1;
                        next_cycle_cnt = 14'd999;
                    end
                end else begin
                    next_cycle_cnt = cycle_cnt - 1'b1;
                end
            end
            WAIT_ACK: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
