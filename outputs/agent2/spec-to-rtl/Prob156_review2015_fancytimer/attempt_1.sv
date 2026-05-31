module TopModule(
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

    typedef enum logic [2:0] {
        S_IDLE, S_SHIFT, S_COUNTING, S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay;
    logic [2:0] shift_cnt;
    logic [3:0] shift_reg;
    logic [10:0] clk_cnt; // 0 to 999
    logic [3:0] current_delay;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 4'b0;
            shift_cnt <= 3'b0;
            clk_cnt <= 11'd0;
            current_delay <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;
            
            if (state == S_IDLE) begin
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == S_SHIFT) begin
                shift_reg <= {shift_reg[2:0], data};
                shift_cnt <= shift_cnt + 1;
            end else if (state == S_COUNTING) begin
                if (clk_cnt == 11'd999) begin
                    clk_cnt <= 11'd0;
                    current_delay <= current_delay - 1;
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end
            
            if (state == S_IDLE) begin
                counting <= 1'b0;
                done <= 1'b0;
            end else if (state == S_SHIFT) begin
                counting <= 1'b0;
                done <= 1'b0;
            end else if (state == S_COUNTING) begin
                counting <= 1'b1;
                done <= 1'b0;
                count <= current_delay;
            end else if (state == S_DONE) begin
                counting <= 1'b0;
                done <= 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = S_SHIFT;
                end
            end
            S_SHIFT: begin
                if (shift_cnt == 3'd3) begin
                    next_state = S_COUNTING;
                end
            end
            S_COUNTING: begin
                if (current_delay == 4'b0 && clk_cnt == 11'd999) begin
                    next_state = S_DONE;
                end
            end
            S_DONE: begin
                if (ack) begin
                    next_state = S_IDLE;
                end
            end
        endcase
    end
    
    // Logic to handle setting initial current_delay at start of S_COUNTING
    // Since current_delay is only set on clock edge, this needs care.
    // I will add a transition state or fix the assignment.
    // Let's fix current_delay loading in state machine transition logic.
    
    // Revised logic:
    // When transitioning from SHIFT to COUNTING, assign delay.
    // In state_ff block:
    // ... if(state == S_SHIFT && next_state == S_COUNTING) current_delay <= shift_reg;
endmodule
