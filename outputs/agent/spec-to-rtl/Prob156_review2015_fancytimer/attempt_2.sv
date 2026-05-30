module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    localparam S_IDLE = 0, S_S1 = 1, S_S2 = 2, S_S3 = 3, S_S4 = 4, S_LOAD = 5, S_COUNT = 6, S_DONE = 7;
    logic [2:0] state, next_state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [9:0] cycle_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 4'b0;
            delay_val <= 4'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            cycle_cnt <= 10'd999;
        end else begin
            state <= next_state;
            case (state)
                S_IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    done <= 1'b0;
                    counting <= 1'b0;
                end
                S_S1, S_S2, S_S3, S_S4: begin
                    delay_val <= {delay_val[2:0], data};
                end
                S_LOAD: begin
                    count <= delay_val;
                    cycle_cnt <= 10'd999;
                    counting <= 1'b1;
                end
                S_COUNT: begin
                    if (cycle_cnt == 0) begin
                        cycle_cnt <= 10'd999;
                        count <= count - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt - 1'b1;
                    end
                end
                S_DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: if (shift_reg == 4'b1101) next_state = S_S1;
            S_S1: next_state = S_S2;
            S_S2: next_state = S_S3;
            S_S3: next_state = S_S4;
            S_S4: next_state = S_LOAD;
            S_LOAD: next_state = S_COUNT;
            S_COUNT: if (count == 0 && cycle_cnt == 0) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end
endmodule
