module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    typedef enum logic [3:0] {
        IDLE,
        S1,
        S11,
        S110,
        READ_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay;
    logic [2:0] delay_idx;
    logic [15:0] cycle_cnt;
    logic [3:0] current_count;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (data) next_state = S1;
            S1:   if (data) next_state = S11; else next_state = IDLE;
            S11:  if (!data) next_state = S110; else next_state = S11;
            S110: if (data) next_state = READ_DELAY; else next_state = IDLE;
            READ_DELAY: if (delay_idx == 4) next_state = COUNTING;
            COUNTING: if (current_count == 0 && cycle_cnt == 999) next_state = DONE;
            DONE: if (ack) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay <= 0;
            delay_idx <= 0;
            cycle_cnt <= 0;
            current_count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            case (state)
                READ_DELAY: begin
                    if (delay_idx < 4) begin
                        delay <= {delay[2:0], data};
                        delay_idx <= delay_idx + 1;
                    end
                end
                COUNTING: begin
                    counting <= 1;
                    if (cycle_cnt == 999) begin
                        cycle_cnt <= 0;
                        if (current_count > 0)
                            current_count <= current_count - 1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end
                DONE: begin
                    counting <= 0;
                    done <= 1;
                end
                IDLE: begin
                    done <= 0;
                    cycle_cnt <= 0;
                    delay_idx <= 0;
                    current_count <= delay;
                end
                default: begin
                    counting <= 0;
                    done <= 0;
                end
            endcase
        end
    end

    assign count = (state == COUNTING) ? current_count : 4'd0;

endmodule
