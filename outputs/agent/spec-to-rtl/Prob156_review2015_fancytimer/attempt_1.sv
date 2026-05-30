module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

    localparam IDLE = 3'd0, DETECT = 3'd1, SHIFT = 3'd2, COUNT = 3'd3, DONE_STATE = 3'd4;
    logic [2:0] state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] bit_cnt;
    logic [3:0] delay_val;
    logic [9:0] cycle_cnt;
    logic [3:0] remaining_delay;

    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (shift_reg == 4'b1101) ? SHIFT : IDLE;
            DETECT: next_state = (shift_reg == 4'b1101) ? SHIFT : DETECT;
            SHIFT: next_state = (bit_cnt == 3'd3) ? COUNT : SHIFT;
            COUNT: next_state = (remaining_delay == 4'd0 && cycle_cnt == 10'd999) ? DONE_STATE : COUNT;
            DONE_STATE: next_state = ack ? IDLE : DONE_STATE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            bit_cnt <= 3'd0;
            delay_val <= 4'd0;
            cycle_cnt <= 10'd0;
            remaining_delay <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            case (state)
                IDLE, DETECT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                SHIFT: begin
                    if (bit_cnt < 3'd4) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                    if (bit_cnt == 3'd3) begin
                        remaining_delay <= {delay_val[2:0], data};
                        counting <= 1'b1;
                        cycle_cnt <= 10'd0;
                    end
                end
                COUNT: begin
                    counting <= 1'b1;
                    count <= remaining_delay;
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        remaining_delay <= remaining_delay - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end
                end
                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end
endmodule