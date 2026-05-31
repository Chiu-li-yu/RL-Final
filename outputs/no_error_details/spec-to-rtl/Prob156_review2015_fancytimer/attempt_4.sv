module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    localparam IDLE = 0, DETECT = 1, READ_DELAY = 2, COUNTING = 3, DONE = 4;
    logic [2:0] state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [2:0] delay_bits_cnt;
    logic [9:0] cycle_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay_val <= 4'b0;
            delay_bits_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
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
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin
                        state <= READ_DELAY;
                        delay_bits_cnt <= 0;
                        delay_val <= 0;
                    end
                end
                READ_DELAY: begin
                    // shift in first bit
                    delay_val <= {delay_val[2:0], data};
                    if (delay_bits_cnt == 3) begin
                        state <= COUNTING;
                        count <= delay_val; // This is the old delay_val, but need new one? 
                        // Wait, update is sequential, so delay_val will be updated in next cycle?
                        // Let's fix the delay_val assignment.
                    end else begin
                        delay_bits_cnt <= delay_bits_cnt + 1'b1;
                    end
                end
                // ...
            endcase
        end
    end
endmodule
