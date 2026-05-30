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
        S_IDLE, S_SHIFT, S_COUNT, S_DONE
    } state_t;

    state_t state;
    logic [3:0] delay_reg;
    logic [2:0] shift_count;
    logic [3:0] pattern_reg;
    logic [10:0] clk_counter; // For counting up to 1000

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_reg <= 4'b0000;
            delay_reg <= 4'b0;
            shift_count <= 0;
            clk_counter <= 0;
            count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 0;
                    counting <= 0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= S_SHIFT;
                        shift_count <= 3;
                    end
                end
                S_SHIFT: begin
                    delay_reg[shift_count] <= data;
                    if (shift_count == 0) begin
                        state <= S_COUNT;
                        count <= delay_reg;
                        clk_counter <= 0;
                        counting <= 1;
                    end else begin
                        shift_count <= shift_count - 1;
                    end
                end
                S_COUNT: begin
                    if (clk_counter == 10'd999) begin
                        clk_counter <= 0;
                        if (count == 0) begin
                            state <= S_DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            count <= count - 1;
                        end
                    end else begin
                        clk_counter <= clk_counter + 1;
                    end
                end
                S_DONE: begin
                    if (ack) begin
                        state <= S_IDLE;
                        done <= 0;
                        pattern_reg <= 4'b0000;
                    end
                end
            endcase
        end
    end
endmodule