module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    logic [2:0] state, next_state;
    parameter S_IDLE = 3'd0, S_P1 = 3'd1, S_P11 = 3'd2, S_P110 = 3'd3, S_SHIFT = 3'd4, S_COUNTING = 3'd5, S_DONE = 3'd6;

    logic [3:0] delay_reg;
    logic [2:0] shift_idx;
    logic [11:0] clk_cnt;
    logic [3:0] remaining_time;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay_reg <= 4'b0;
            shift_idx <= 3'b0;
            clk_cnt <= 12'b0;
            remaining_time <= 4'b0;
        end else begin
            state <= next_state;
            case (state)
                S_IDLE: begin
                    shift_idx <= 3'b0;
                end
                S_SHIFT: begin
                    delay_reg <= {delay_reg[2:0], data};
                    shift_idx <= shift_idx + 1'b1;
                    if (shift_idx == 3'd3) remaining_time <= {delay_reg[2:0], data};
                end
                S_COUNTING: begin
                    if (clk_cnt == 12'd999) begin
                        clk_cnt <= 12'b0;
                        remaining_time <= remaining_time - 1'b1;
                    end else begin
                        clk_cnt <= clk_cnt + 1'b1;
                    end
                end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE: if (data) next_state = S_P1;
            S_P1: next_state = data ? S_P11 : S_IDLE;
            S_P11: next_state = data ? S_P11 : S_P110;
            S_P110: next_state = data ? S_SHIFT : S_IDLE;
            S_SHIFT: if (shift_idx == 3'd3) next_state = S_COUNTING;
            S_COUNTING: if (remaining_time == 4'b0 && clk_cnt == 12'd999) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end

    assign count = (state == S_COUNTING) ? remaining_time : 4'b0;
    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);

endmodule