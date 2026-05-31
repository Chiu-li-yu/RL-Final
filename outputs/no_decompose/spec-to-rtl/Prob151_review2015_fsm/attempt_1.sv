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

    typedef enum logic [3:0] {
        IDLE,
        S1,
        S11,
        S110,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    state_t current_state, next_state;
    logic [1:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_count <= 2'b0;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'b0;
            end
        end
    end

    always @(*) begin
        next_state = current_state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S11 : IDLE;
            S11:  next_state = data ? S11 : S110;
            S110: next_state = data ? SHIFT : IDLE;
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 2'd3) next_state = COUNTING;
            end
            COUNTING: begin
                counting = 1'b1;
                if (done_counting) next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
