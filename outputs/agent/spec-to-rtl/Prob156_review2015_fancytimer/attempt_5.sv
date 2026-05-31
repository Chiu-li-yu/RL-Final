module TopModule(
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    typedef enum logic [2:0] {S_IDLE, S_SHIFT, S_COUNT, S_DONE} state_t;
    state_t state, next_state;
    logic [3:0] pattern_reg;
    logic [3:0] delay_reg;
    logic [2:0] bit_cnt;
    logic [9:0] cycle_cnt;
    logic [3:0] timer_val;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_reg <= 4'b0;
            bit_cnt <= 3'd0;
            delay_reg <= 4'b0;
            cycle_cnt <= 10'd0;
            timer_val <= 4'b0;
        end else begin
            state <= next_state;
            case(state)
                S_IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end
                S_SHIFT: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_cnt <= bit_cnt + 3'd1;
                    if (bit_cnt == 3'd3) timer_val <= {delay_reg[2:0], data};
                end
                S_COUNT: begin
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        timer_val <= timer_val - 1'd1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 10'd1;
                    end
                end
                S_DONE: begin
                end
            endcase
            
            if (state == S_IDLE && next_state == S_SHIFT) bit_cnt <= 3'd0;
        end
    end

    always_comb begin
        next_state = state;
        case(state)
            S_IDLE: if (pattern_reg == 4'b1101) next_state = S_SHIFT;
            S_SHIFT: if (bit_cnt == 3'd3) next_state = S_COUNT;
            S_COUNT: if (timer_val == 4'd0 && cycle_cnt == 10'd999) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end

    assign counting = (state == S_COUNT);
    assign done = (state == S_DONE);
    assign count = timer_val;
endmodule
