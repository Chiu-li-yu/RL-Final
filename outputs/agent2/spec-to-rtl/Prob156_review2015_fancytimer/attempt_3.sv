module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

    localparam S_IDLE  = 3'd0,
               S_SHIFT = 3'd1,
               S_COUNT = 3'd2,
               S_DONE  = 3'd3;

    logic [2:0] state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] shift_cnt;
    logic [3:0] delay;
    logic [9:0] cycle_cnt;
    logic [3:0] timer_count;

    always @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: if (shift_reg == 4'b1101) next_state = S_SHIFT;
            S_SHIFT: if (shift_cnt == 4) next_state = S_COUNT;
            S_COUNT: if (timer_count == 0 && cycle_cnt == 999) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
            shift_cnt <= 0;
            delay <= 0;
            cycle_cnt <= 0;
            timer_count <= 0;
            counting <= 0;
            done <= 0;
            count <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                end
                S_SHIFT: begin
                    if (shift_cnt < 4) begin
                        delay <= {delay[2:0], data};
                        shift_cnt <= shift_cnt + 1;
                    end else begin
                        timer_count <= delay;
                        cycle_cnt <= 0;
                        counting <= 1;
                    end
                end
                S_COUNT: begin
                    counting <= 1;
                    if (cycle_cnt == 999) begin
                        cycle_cnt <= 0;
                        if (timer_count == 0) begin
                            counting <= 0;
                            done <= 1;
                        end else begin
                            timer_count <= timer_count - 1;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                    count <= timer_count;
                end
                S_DONE: begin
                    done <= 1;
                    counting <= 0;
                    if (ack) begin
                        shift_reg <= 0;
                        shift_cnt <= 0;
                        done <= 0;
                    end
                end
            endcase
        end
    end
endmodule
