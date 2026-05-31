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
        SEARCH, GET_DELAY, COUNTING, WAIT_ACK
    } state_t;

    state_t state;
    logic [3:0] shift_reg;
    logic [2:0] bit_cnt;
    logic [3:0] delay_val;
    logic [9:0] cycle_cnt;
    logic [3:0] remaining;

    assign count = remaining;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 0;
            bit_cnt <= 0;
            delay_val <= 0;
            cycle_cnt <= 0;
            remaining <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                SEARCH: begin
                    done <= 0;
                    counting <= 0;
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin // Detect 1101
                        state <= GET_DELAY;
                        bit_cnt <= 0;
                        delay_val <= 0;
                    end
                end
                GET_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3) begin
                        state <= COUNTING;
                        remaining <= {delay_val[2:0], data};
                        cycle_cnt <= 0;
                        counting <= 1;
                    end
                end
                COUNTING: begin
                    if (cycle_cnt == 999) begin
                        cycle_cnt <= 0;
                        if (remaining == 0) begin
                            state <= WAIT_ACK;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            remaining <= remaining - 1;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end
                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 0;
                        shift_reg <= 0;
                    end
                end
            endcase
        end
    end
endmodule