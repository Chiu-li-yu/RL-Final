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
        SEARCH,
        GET_DELAY,
        COUNTING,
        WAIT_ACK
    } state_t;

    state_t state;
    logic [3:0] shift_reg;
    logic [2:0] bit_cnt;
    logic [3:0] delay_val;
    logic [15:0] cycle_cnt;
    logic [3:0] current_count;

    assign count = current_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0;
            bit_cnt <= 3'b0;
            delay_val <= 4'b0;
            cycle_cnt <= 16'b0;
            current_count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin
                        state <= GET_DELAY;
                        bit_cnt <= 3'b0;
                    end
                end
                GET_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3'd3) begin
                        state <= COUNTING;
                        current_count <= {delay_val[2:0], data};
                        cycle_cnt <= 16'd0;
                        counting <= 1'b1;
                    end
                end
                COUNTING: begin
                    if (cycle_cnt == 16'd999) begin
                        cycle_cnt <= 16'd0;
                        if (current_count == 4'd0) begin
                            state <= WAIT_ACK;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            current_count <= current_count - 1;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end
                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 1'b0;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end
endmodule
