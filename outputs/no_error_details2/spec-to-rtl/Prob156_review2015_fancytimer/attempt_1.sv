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
        S_IDLE, S_1, S_11, S_110, S_READ_DELAY, S_COUNT, S_DONE
    } state_t;

    state_t state;
    logic [3:0] delay_val;
    logic [3:0] bit_cnt;
    logic [9:0] cycle_cnt;
    logic [3:0] current_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay_val <= 4'd0;
            bit_cnt <= 4'd0;
            cycle_cnt <= 10'd0;
            current_count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (data) state <= S_1;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                S_1: state <= data ? S_11 : S_IDLE;
                S_11: state <= data ? S_11 : S_110;
                S_110: begin
                    if (data) begin
                        state <= S_READ_DELAY;
                        bit_cnt <= 4'd0;
                    end else state <= S_IDLE;
                end
                S_READ_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 4'd3) begin
                        state <= S_COUNT;
                        current_count <= {delay_val[2:0], data};
                        cycle_cnt <= 10'd0;
                        counting <= 1'b1;
                    end
                end
                S_COUNT: begin
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (current_count == 4'd0) begin
                            state <= S_DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            current_count <= current_count - 1;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end
                S_DONE: begin
                    if (ack) state <= S_IDLE;
                end
            endcase
        end
    end

    assign count = (state == S_COUNT) ? current_count : 4'd0;

endmodule
