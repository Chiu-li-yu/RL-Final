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
        S_IDLE,
        S_1, S_11, S_110,
        S_READ_DELAY,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay_val;
    logic [2:0] bit_cnt;
    logic [15:0] timer_cnt; // Max delay 15+1=16 * 1000 = 16000 cycles (needs 15 bits)
    logic [3:0] current_timer_val;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay_val <= 0;
            bit_cnt <= 0;
            timer_cnt <= 0;
            current_timer_val <= 0;
        end else begin
            state <= next_state;
            if (state == S_READ_DELAY && next_state == S_READ_DELAY) begin
                delay_val <= {delay_val[2:0], data};
                bit_cnt <= bit_cnt + 1;
            end else if (state == S_READ_DELAY && next_state == S_COUNTING) begin
                delay_val <= {delay_val[2:0], data};
                current_timer_val <= {delay_val[2:0], data};
                timer_cnt <= 1000 - 1;
            end else if (state == S_COUNTING) begin
                if (timer_cnt == 0) begin
                    if (current_timer_val == 0) begin
                    end else begin
                        current_timer_val <= current_timer_val - 1;
                        timer_cnt <= 1000 - 1;
                    end
                end else begin
                    timer_cnt <= timer_cnt - 1;
                end
            end else if (state == S_IDLE) begin
                bit_cnt <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: if (data) next_state = S_1;
            S_1: if (data) next_state = S_11; else next_state = S_IDLE;
            S_11: if (!data) next_state = S_110; else next_state = S_11;
            S_110: if (data) next_state = S_READ_DELAY; else next_state = S_IDLE;
            S_READ_DELAY: if (bit_cnt == 3) next_state = S_COUNTING;
            S_COUNTING: if (current_timer_val == 0 && timer_cnt == 0) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end

    assign count = (state == S_COUNTING) ? current_timer_val : 4'd0;
    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);

endmodule
