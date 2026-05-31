module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

    typedef enum logic [2:0] {
        S_IDLE, S_SHIFT, S_COUNT, S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] shift_cnt;
    logic [3:0] delay;
    logic [11:0] cycle_cnt;
    logic [3:0] timer_count;

    always @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (shift_reg == 4'b1101) next_state = S_SHIFT;
            end
            S_SHIFT: begin
                if (shift_cnt == 4) next_state = S_COUNT;
            end
            S_COUNT: begin
                if (timer_count == 0 && cycle_cnt == 999) next_state = S_DONE;
            end
            S_DONE: begin
                if (ack) next_state = S_IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
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
                    end
                end
                S_COUNT: begin
                    counting <= 1;
                    if (cycle_cnt == 999) begin
                        cycle_cnt <= 0;
                        if (timer_count > 0) timer_count <= timer_count - 1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                    count <= timer_count;
                end
                S_DONE: begin
                    counting <= 0;
                    done <= 1;
                    shift_reg <= 0;
                    shift_cnt <= 0;
                    timer_count <= delay;
                end
            endcase
        end
    end

endmodule
