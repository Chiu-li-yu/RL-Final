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
        IDLE, S1, S11, S110, READ_DELAY, COUNTING, DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay, next_delay;
    logic [2:0] bit_cnt, next_bit_cnt;
    logic [10:0] clk_cnt, next_clk_cnt;
    logic [3:0] cur_count, next_cur_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay <= 0;
            bit_cnt <= 0;
            clk_cnt <= 0;
            cur_count <= 0;
        end else begin
            state <= next_state;
            delay <= next_delay;
            bit_cnt <= next_bit_cnt;
            clk_cnt <= next_clk_cnt;
            cur_count <= next_cur_count;
        end
    end

    always @(*) begin
        next_state = state;
        next_delay = delay;
        next_bit_cnt = bit_cnt;
        next_clk_cnt = clk_cnt;
        next_cur_count = cur_count;
        counting = 0;
        done = 0;
        count = cur_count;

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
                else next_state = S11;
            end
            S110: begin
                if (data) begin
                    next_state = READ_DELAY;
                    next_bit_cnt = 0;
                end else next_state = IDLE;
            end
            READ_DELAY: begin
                next_delay = {delay[2:0], data};
                if (bit_cnt == 3) begin
                    next_state = COUNTING;
                    next_clk_cnt = 0;
                    next_cur_count = {delay[2:0], data};
                end else begin
                    next_bit_cnt = bit_cnt + 1;
                end
            end
            COUNTING: begin
                counting = 1;
                if (clk_cnt == 1000 - 1) begin
                    next_clk_cnt = 0;
                    if (cur_count == 0) begin
                        next_state = DONE;
                    end else begin
                        next_cur_count = cur_count - 1;
                    end
                end else begin
                    next_clk_cnt = clk_cnt + 1;
                end
            end
            DONE: begin
                done = 1;
                if (ack) next_state = IDLE;
            end
        endcase
    end
endmodule
