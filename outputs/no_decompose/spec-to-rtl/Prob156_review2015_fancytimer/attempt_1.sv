module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    typedef enum logic [2:0] {
        S_IDLE,
        S_PATTERN_1, S_PATTERN_11, S_PATTERN_110,
        S_SHIFT_DELAY,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay_val;
    logic [2:0] shift_cnt;
    logic [11:0] clk_cnt;
    logic [3:0] current_delay;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay_val <= 4'b0;
            shift_cnt <= 3'b0;
            clk_cnt <= 12'b0;
            current_delay <= 4'b0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT_DELAY) begin
                if (shift_cnt < 3'd3) begin
                    delay_val <= {delay_val[2:0], data};
                    shift_cnt <= shift_cnt + 1'b1;
                end else begin
                    delay_val <= {delay_val[2:0], data};
                end
            end else if (state == S_COUNTING) begin
                if (clk_cnt == 12'd999) begin
                    clk_cnt <= 12'b0;
                    current_delay <= current_delay - 1'b1;
                end else begin
                    clk_cnt <= clk_cnt + 1'b1;
                end
            end else if (state == S_IDLE) begin
                shift_cnt <= 3'b0;
            end else if (state == S_PATTERN_110) begin
                // Transitioning to S_SHIFT_DELAY: capture the 4th bit
                // Logic handled in next_state logic
            end
        end
    end

    // Special logic for capturing the first bit of delay and state initiation
    always_ff @(posedge clk) begin
        if (reset) begin
            current_delay <= 4'b0;
        end else if (state == S_PATTERN_110) begin
            current_delay <= {delay_val[2:0], data};
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE: if (data) next_state = S_PATTERN_1;
            S_PATTERN_1: next_state = data ? S_PATTERN_11 : S_IDLE;
            S_PATTERN_11: next_state = data ? S_PATTERN_11 : S_PATTERN_110;
            S_PATTERN_110: next_state = data ? S_SHIFT_DELAY : S_IDLE;
            S_SHIFT_DELAY: if (shift_cnt == 3'd3) next_state = S_COUNTING;
            S_COUNTING: if (current_delay == 4'b0 && clk_cnt == 12'd999) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end

    assign count = (state == S_COUNTING) ? current_delay : 4'b0;
    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);

endmodule