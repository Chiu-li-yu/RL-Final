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
        S_IDLE,
        S_GOT_1,
        S_GOT_11,
        S_GOT_110,
        S_SHIFT,
        S_COUNT,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT) begin
                if (shift_cnt == 3'd3)
                    shift_cnt <= 3'd0;
                else
                    shift_cnt <= shift_cnt + 3'd1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            S_IDLE: begin
                if (data) next_state = S_GOT_1;
            end
            S_GOT_1: begin
                if (data) next_state = S_GOT_11;
                else next_state = S_IDLE;
            end
            S_GOT_11: begin
                if (!data) next_state = S_GOT_110;
                else next_state = S_GOT_11;
            end
            S_GOT_110: begin
                if (data) next_state = S_SHIFT;
                else next_state = S_IDLE;
            end
            S_SHIFT: begin
                shift_ena = 1'b1;
                if (shift_cnt == 3'd3) next_state = S_COUNT;
            end
            S_COUNT: begin
                counting = 1'b1;
                if (done_counting) next_state = S_DONE;
            end
            S_DONE: begin
                done = 1'b1;
                if (ack) next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end
endmodule