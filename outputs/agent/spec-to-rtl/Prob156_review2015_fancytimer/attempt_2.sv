module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    localparam S_IDLE = 0, S_S1 = 1, S_S11 = 2, S_S110 = 3, S_SHIFT = 4, S_COUNT = 5, S_DONE = 6;
    logic [2:0] state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] shift_cnt;
    logic [3:0] delay_val;
    logic [3:0] cur_count;
    logic [9:0] cycle_cnt;

    always_ff @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
            shift_cnt <= 0;
            delay_val <= 0;
            cur_count <= 0;
            cycle_cnt <= 0;
        end else begin
            case (state)
                S_SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_cnt == 3) begin
                        delay_val <= {shift_reg[2:0], data};
                        cur_count <= {shift_reg[2:0], data};
                        cycle_cnt <= 999;
                    end
                    shift_cnt <= shift_cnt + 1;
                end
                S_COUNT: begin
                    if (cycle_cnt == 0) begin
                        if (cur_count == 0) begin
                        end else begin
                            cur_count <= cur_count - 1;
                            cycle_cnt <= 999;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt - 1;
                    end
                end
                S_IDLE: begin
                    shift_cnt <= 0;
                end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        counting = 0;
        done = 0;
        count = cur_count;
        case (state)
            S_IDLE: if (data) next_state = S_S1;
            S_S1: if (data) next_state = S_S11; else next_state = S_IDLE;
            S_S11: if (~data) next_state = S_S110; else next_state = S_S11;
            S_S110: if (data) next_state = S_SHIFT; else next_state = S_IDLE;
            S_SHIFT: if (shift_cnt == 3) next_state = S_COUNT;
            S_COUNT: begin
                counting = 1;
                if (cur_count == 0 && cycle_cnt == 0) next_state = S_DONE;
            end
            S_DONE: begin
                done = 1;
                if (ack) next_state = S_IDLE;
            end
        endcase
    end
endmodule
