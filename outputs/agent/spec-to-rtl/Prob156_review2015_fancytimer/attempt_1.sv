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
        S_IDLE, S_S1, S_S11, S_S110, S_SHIFT, S_COUNT, S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay;
    logic [2:0] shift_cnt;
    logic [3:0] shift_reg;
    logic [15:0] cycle_cnt;
    logic [3:0] current_delay;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_cnt <= 0;
            shift_reg <= 0;
            delay <= 0;
            cycle_cnt <= 0;
            current_delay <= 0;
        end else begin
            state <= next_state;

            case (state)
                S_IDLE: begin
                    shift_reg <= 0;
                end
                S_SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_cnt == 3) begin
                        delay <= {shift_reg[2:0], data};
                        current_delay <= {shift_reg[2:0], data};
                        cycle_cnt <= 999;
                    end
                    shift_cnt <= shift_cnt + 1;
                end
                S_COUNT: begin
                    if (cycle_cnt == 0) begin
                        if (current_delay == 0) begin
                            // Finish
                        end else begin
                            current_delay <= current_delay - 1;
                            cycle_cnt <= 999;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt - 1;
                    end
                end
                S_DONE: begin
                    if (ack) begin
                        // Done waiting
                    end
                end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        counting = 0;
        done = 0;
        count = current_delay;

        case (state)
            S_IDLE: begin
                if (data) next_state = S_S1;
            end
            S_S1: begin
                if (data) next_state = S_S11;
                else next_state = S_IDLE;
            end
            S_S11: begin
                if (!data) next_state = S_S110;
            end
            S_S110: begin
                if (data) next_state = S_SHIFT;
                else next_state = S_IDLE;
            end
            S_SHIFT: begin
                if (shift_cnt == 3) next_state = S_COUNT;
            end
            S_COUNT: begin
                counting = 1;
                if (current_delay == 0 && cycle_cnt == 0) next_state = S_DONE;
            end
            S_DONE: begin
                done = 1;
                if (ack) next_state = S_IDLE;
            end
        endcase
    end
endmodule
