module TopModule(
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    typedef enum logic [2:0] {
        S_SEARCH, S_SHIFT, S_COUNT, S_DONE
    } state_t;

    state_t state;
    logic [3:0] delay_reg;
    logic [3:0] shift_reg;
    logic [2:0] shift_ptr;
    logic [15:0] timer;
    logic [3:0] pattern;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern <= 4'b0;
            delay_reg <= 4'b0;
            shift_ptr <= 4'd3;
            timer <= 16'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                S_SEARCH: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern[2:0] == 3'b110 && data == 1'b1) begin
                        state <= S_SHIFT;
                        shift_ptr <= 3;
                    end
                end
                S_SHIFT: begin
                    delay_reg[shift_ptr] <= data;
                    if (shift_ptr == 0) begin
                        state <= S_COUNT;
                        timer <= 16'd1000;
                        count <= {delay_reg[3:1], data};
                        counting <= 1'b1;
                    end else begin
                        shift_ptr <= shift_ptr - 1;
                    end
                end
                S_COUNT: begin
                    if (timer == 1) begin
                        if (count == 0) begin
                            state <= S_DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            timer <= 16'd1000;
                            count <= count - 1;
                        end
                    end else begin
                        timer <= timer - 1;
                    end
                end
                S_DONE: begin
                    if (ack) begin
                        state <= S_SEARCH;
                        done <= 1'b0;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end
endmodule
