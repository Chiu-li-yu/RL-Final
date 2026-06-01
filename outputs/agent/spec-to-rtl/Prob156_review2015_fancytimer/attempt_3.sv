module TopModule(
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    localparam S_IDLE = 3'd0, S_SHIFT = 3'd1, S_COUNTING = 3'd2, S_DONE = 3'd3;
    logic [2:0] state, next_state;
    logic [3:0] delay_reg;
    logic [2:0] shift_cnt;
    logic [3:0] pattern_reg;
    logic [10:0] clk_cnt;
    logic [3:0] current_val;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_reg <= 4'b0;
            shift_cnt <= 3'd0;
            delay_reg <= 4'b0;
            clk_cnt <= 11'd0;
            current_val <= 4'b0;
        end else begin
            state <= next_state;
            case (state)
                S_IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end
                S_SHIFT: begin
                    if (shift_cnt < 3'd4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        shift_cnt <= shift_cnt + 3'd1;
                    end
                end
                S_COUNTING: begin
                    if (clk_cnt == 11'd999) begin
                        clk_cnt <= 11'd0;
                        current_val <= current_val - 1'd1;
                    end else begin
                        clk_cnt <= clk_cnt + 11'd1;
                    end
                end
            endcase
            
            if (state == S_IDLE && next_state == S_SHIFT) begin
                // reset for shift
                shift_cnt <= 3'd0;
            end
            if (state == S_SHIFT && shift_cnt == 3'd3) begin
                // When we shift the last bit, it should load.
                // The current code loads it in the next cycle.
                // Let's refine the load time.
            end
        end
    end

    // Use a Moore-like current_val update
    always_comb begin
        next_state = state;
        case (state)
            S_IDLE: if (pattern_reg == 4'b1101) next_state = S_SHIFT;
            S_SHIFT: if (shift_cnt == 3'd4) next_state = S_COUNTING;
            S_COUNTING: if (current_val == 4'b0 && clk_cnt == 11'd999) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end

    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);
    assign count = current_val;
endmodule
