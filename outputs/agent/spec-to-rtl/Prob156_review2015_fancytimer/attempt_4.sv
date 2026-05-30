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
    logic [3:0] delay_val;
    logic [2:0] shift_bit_cnt;
    logic [9:0] clk_div;
    logic [3:0] remain_cnt;

    always_ff @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE: next_state = (data) ? S_S1 : S_IDLE;
            S_S1:   next_state = (data) ? S_S11 : S_IDLE;
            S_S11:  next_state = (data) ? S_S11 : S_S110;
            S_S110: next_state = (data) ? S_SHIFT : S_IDLE;
            S_SHIFT: next_state = (shift_bit_cnt == 3) ? S_COUNT : S_SHIFT;
            S_COUNT: next_state = (remain_cnt == 0 && clk_div == 999) ? S_DONE : S_COUNT;
            S_DONE:  next_state = (ack) ? S_IDLE : S_DONE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            shift_bit_cnt <= 0;
            delay_val <= 0;
            clk_div <= 0;
            remain_cnt <= 0;
            count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    shift_bit_cnt <= 0;
                    done <= 0;
                    counting <= 0;
                end
                S_SHIFT: begin
                    delay_val <= {delay_val[2:0], data};
                    if (shift_bit_cnt == 3) begin
                        remain_cnt <= {delay_val[2:0], data};
                        count <= {delay_val[2:0], data};
                        counting <= 1;
                    end else begin
                        shift_bit_cnt <= shift_bit_cnt + 1;
                    end
                end
                S_COUNT: begin
                    if (clk_div == 999) begin
                        clk_div <= 0;
                        if (remain_cnt > 0) begin
                            remain_cnt <= remain_cnt - 1;
                            count <= remain_cnt - 1;
                        end else begin
                            counting <= 0;
                            done <= 1;
                        end
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end
                S_DONE: begin
                    done <= 1;
                    counting <= 0;
                end
            endcase
        end
    end
endmodule
