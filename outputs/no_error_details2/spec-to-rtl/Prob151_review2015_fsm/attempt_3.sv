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
    // Use logic instead of reg/wire
    logic [3:0] shift_reg;
    typedef enum logic [2:0] {IDLE, SHIFT, COUNTING, DONE_ST} state_t;
    state_t state, next_state;
    logic [2:0] shift_cnt;

    // FSM State transitions
    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    // Pattern detection shift register
    always_ff @(posedge clk) begin
        if (reset) shift_reg <= 4'b0000;
        else if (state == IDLE) shift_reg <= {shift_reg[2:0], data};
    end

    // Shift counter
    always_ff @(posedge clk) begin
        if (reset) shift_cnt <= 3'd0;
        else if (state == SHIFT) shift_cnt <= shift_cnt + 1'b1;
        else shift_cnt <= 3'd0;
    end

    // FSM logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) next_state = SHIFT;
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_cnt == 3'd3) next_state = COUNTING;
            end
            COUNTING: begin
                counting = 1'b1;
                if (done_counting) next_state = DONE_ST;
            end
            DONE_ST: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
        endcase
    end
endmodule