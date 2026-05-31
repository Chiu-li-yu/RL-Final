module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    localparam S_IDLE = 0, S_1 = 1, S_11 = 2, S_110 = 3, S_READ = 4, S_COUNT = 5, S_DONE = 6;
    logic [2:0] state;
    logic [3:0] delay_val;
    logic [2:0] bit_cnt;
    logic [9:0] cycle_cnt;
    logic [3:0] current_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            counting <= 0;
            done <= 0;
            bit_cnt <= 0;
            delay_val <= 0;
            cycle_cnt <= 0;
            current_count <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (data) state <= S_1;
                    counting <= 0;
                    done <= 0;
                end
                S_1: state <= data ? S_11 : S_IDLE;
                S_11: state <= data ? S_11 : S_110;
                S_110: if (data) begin state <= S_READ; bit_cnt <= 0; delay_val <= 0; end else state <= S_IDLE;
                S_READ: begin
                    delay_val <= {delay_val[2:0], data};
                    if (bit_cnt == 3) begin
                        state <= S_COUNT;
                        current_count <= {delay_val[2:0], data};
                        cycle_cnt <= 0;
                        counting <= 1;
                    end else bit_cnt <= bit_cnt + 1;
                end
                S_COUNT: begin
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 0;
                        if (current_count == 4'd0) begin
                            state <= S_DONE;
                            counting <= 0;
                            done <= 1;
                        end else current_count <= current_count - 1;
                    end else cycle_cnt <= cycle_cnt + 1;
                end
                S_DONE: if (ack) state <= S_IDLE;
            endcase
        end
    end
    assign count = current_count;
endmodule
