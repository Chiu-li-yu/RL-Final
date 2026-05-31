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
        IDLE,
        DETECT,
        READ_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [9:0] cycles_cnt;
    logic [3:0] current_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay_val <= 4'b0;
            cycles_cnt <= 10'd0;
            current_count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= DETECT;
                    shift_reg <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                DETECT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b110) begin // shift_reg + data == 1101
                        if (data == 1'b1) begin
                            state <= READ_DELAY;
                            cycles_cnt <= 3'd0;
                        end
                    end
                end
                READ_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    cycles_cnt <= cycles_cnt + 1'b1;
                    if (cycles_cnt == 3) begin
                        state <= COUNTING;
                        current_count <= {delay_val[2:0], data}; // final delay value
                        cycles_cnt <= 10'd0;
                        counting <= 1'b1;
                    end
                end
                COUNTING: begin
                    cycles_cnt <= cycles_cnt + 1'b1;
                    if (cycles_cnt == 999) begin
                        cycles_cnt <= 10'd0;
                        if (current_count == 0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            current_count <= current_count - 1'b1;
                        end
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

    assign count = (state == COUNTING || state == READ_DELAY) ? current_count : 4'd0;

endmodule
