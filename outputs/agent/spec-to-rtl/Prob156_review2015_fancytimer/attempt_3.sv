module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    typedef enum logic [1:0] {
        S_SEARCH,
        S_READ_DELAY,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [2:0] bit_cnt;
    logic [9:0] cycle_cnt;
    logic [3:0] current_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            shift_reg <= 4'b0000;
            delay_val <= 4'b0000;
            bit_cnt <= 0;
            cycle_cnt <= 999;
            current_count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                S_SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin
                        state <= S_READ_DELAY;
                        bit_cnt <= 0;
                        delay_val <= 0;
                    end
                end
                S_READ_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3) begin
                        state <= S_COUNTING;
                        current_count <= {delay_val[2:0], data};
                        cycle_cnt <= 999;
                        counting <= 1;
                    end
                end
                S_COUNTING: begin
                    if (cycle_cnt > 0) begin
                        cycle_cnt <= cycle_cnt - 1;
                    end else begin
                        if (current_count > 0) begin
                            current_count <= current_count - 1;
                            cycle_cnt <= 999;
                        end else begin
                            state <= S_DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end
                S_DONE: begin
                    if (ack) begin
                        state <= S_SEARCH;
                        done <= 0;
                        shift_reg <= 0;
                    end
                end
            endcase
        end
    end
    assign count = (state == S_COUNTING) ? current_count : 4'b0;

endmodule
