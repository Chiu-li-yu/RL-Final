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
        S0_SEARCH,
        S1_LOAD,
        S2_COUNT,
        S3_DONE
    } state_t;

    state_t state;
    logic [3:0] shift_reg;
    logic [3:0] delay;
    logic [2:0] load_cnt;
    logic [9:0] cycle_cnt;
    logic [3:0] current_delay;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0_SEARCH;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            load_cnt <= 3'b0;
            cycle_cnt <= 10'd0;
            current_delay <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                S0_SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= S1_LOAD;
                        load_cnt <= 3'd0;
                    end
                end
                S1_LOAD: begin
                    delay <= {delay[2:0], data};
                    if (load_cnt == 3'd3) begin
                        state <= S2_COUNT;
                        current_delay <= {delay[2:0], data}; // final bit
                        cycle_cnt <= 10'd0;
                        counting <= 1'b1;
                    end else begin
                        load_cnt <= load_cnt + 1'b1;
                    end
                end
                S2_COUNT: begin
                    counting <= 1'b1;
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (current_delay == 4'b0) begin
                            state <= S3_DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            current_delay <= current_delay - 1'b1;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end
                end
                S3_DONE: begin
                    done <= 1'b1;
                    if (ack) begin
                        state <= S0_SEARCH;
                        done <= 1'b0;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        if (state == S2_COUNT)
            count = current_delay;
        else
            count = 4'b0;
    end

endmodule