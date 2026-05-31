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
        S_IDLE, S_S1, S_S11, S_S110, S_LOAD, S_COUNT, S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay;
    logic [3:0] shift_reg;
    logic [2:0] shift_cnt;
    logic [13:0] timer_cnt; // (15+1)*1000 = 16000, need 14 bits (2^14 = 16384)

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: if (data) next_state = S_S1;
            S_S1:   if (data) next_state = S_S11; else next_state = S_IDLE;
            S_S11:  if (!data) next_state = S_S110; else next_state = S_S11;
            S_S110: if (data) next_state = S_LOAD; else next_state = S_IDLE;
            S_LOAD: if (shift_cnt == 3'd3) next_state = S_COUNT;
            S_COUNT: if (timer_cnt == 0 && count == 0) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 0;
            shift_cnt <= 0;
            delay <= 0;
            timer_cnt <= 0;
            count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            case (state)
                S_IDLE: begin
                    counting <= 0;
                    done <= 0;
                end
                S_LOAD: begin
                    shift_reg <= {shift_reg[2:0], data};
                    shift_cnt <= shift_cnt + 1;
                    if (shift_cnt == 3'd3) begin
                        delay <= {shift_reg[2:0], data};
                        count <= {shift_reg[2:0], data};
                        timer_cnt <= 14'd999;
                        counting <= 1;
                    end
                end
                S_COUNT: begin
                    if (timer_cnt == 0) begin
                        timer_cnt <= 14'd999;
                        count <= count - 1;
                    end else begin
                        timer_cnt <= timer_cnt - 1;
                    end
                end
                S_DONE: begin
                    counting <= 0;
                    done <= 1;
                end
            endcase
        end
    end
endmodule
