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

    typedef enum logic [2:0] {
        IDLE = 3'd0,
        SHIFT = 3'd1,
        COUNTING = 3'd2,
        DONE = 3'd3
    } state_t;

    state_t state, next_state;
    logic [3:0] pattern;
    logic [1:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == IDLE) begin
                pattern <= {pattern[2:0], data};
            end
            
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'b1;
            end else begin
                shift_count <= 2'b00;
            end
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_count == 2'b11) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule