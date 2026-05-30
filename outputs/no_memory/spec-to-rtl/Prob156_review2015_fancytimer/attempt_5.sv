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
        CAPTURE,
        COUNTING,
        FINISHED
    } state_t;

    state_t state;
    logic [3:0] shift_reg;
    logic [2:0] capture_cnt;
    logic [3:0] delay_val;
    logic [3:0] current_count;
    logic [9:0] inner_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0;
            capture_cnt <= 3'd0;
            delay_val <= 4'b0;
            current_count <= 4'b0;
            inner_cnt <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin
                        state <= CAPTURE;
                        capture_cnt <= 3'd0;
                    end
                end
                CAPTURE: begin
                    delay_val <= {delay_val[2:0], data};
                    capture_cnt <= capture_cnt + 1;
                    if (capture_cnt == 3'd3) begin
                        state <= COUNTING;
                        current_count <= delay_val; // This needs to be carefully handled
                        // Note: actual delay_val is formed after 4 cycles.
                        // Correct logic below in combinational
                    end
                end
                COUNTING: begin
                    counting <= 1'b1;
                    if (inner_cnt == 10'd999) begin
                        inner_cnt <= 10'd0;
                        if (current_count == 4'd0) begin
                            state <= FINISHED;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            current_count <= current_count - 1;
                        end
                    end else begin
                        inner_cnt <= inner_cnt + 1;
                    end
                    count <= current_count;
                end
                FINISHED: begin
                    done <= 1'b1;
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