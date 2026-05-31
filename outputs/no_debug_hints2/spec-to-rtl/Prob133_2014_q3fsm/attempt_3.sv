module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);
    // State definitions
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        COUNTING = 2'd1,
        EVAL = 2'd2
    } state_t;

    state_t state, next_state;
    logic [1:0] count_w;
    logic [1:0] next_count_w;
    logic [1:0] cycle_idx;
    logic [1:0] next_cycle_idx;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count_w <= 2'd0;
            cycle_idx <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            count_w <= next_count_w;
            cycle_idx <= next_cycle_idx;
            
            // Output z is high if we just finished EVAL
            if (state == EVAL) begin
                z <= (count_w == 2'd2);
            end else if (state == IDLE) begin
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        next_count_w = count_w;
        next_cycle_idx = cycle_idx;

        case (state)
            IDLE: begin
                if (s) begin
                    next_state = COUNTING;
                    next_count_w = 2'd0;
                    next_cycle_idx = 2'd0;
                end
            end
            COUNTING: begin
                next_count_w = count_w + (w ? 2'd1 : 2'd0);
                if (cycle_idx == 2'd2) begin
                    next_state = EVAL;
                    next_cycle_idx = 2'd0;
                end else begin
                    next_cycle_idx = cycle_idx + 2'd1;
                end
            end
            EVAL: begin
                next_state = COUNTING;
                next_count_w = 2'd0;
            end
        endcase
    end
endmodule
