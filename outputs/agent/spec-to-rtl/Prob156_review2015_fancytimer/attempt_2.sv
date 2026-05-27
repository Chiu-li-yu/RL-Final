module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    typedef enum logic [2:0] {
        S_SEARCH,
        S_READ_DELAY,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [2:0] bit_cnt;
    logic [9:0] cycle_cnt;
    logic [3:0] current_count;

    always @(*) begin
        next_state = state;
        case (state)
            S_SEARCH: begin
                if (shift_reg == 4'b1101) next_state = S_READ_DELAY;
            end
            S_READ_DELAY: begin
                if (bit_cnt == 4) next_state = S_COUNTING;
            end
            S_COUNTING: begin
                if (current_count == 0 && cycle_cnt == 0) next_state = S_DONE;
            end
            S_DONE: begin
                if (ack) next_state = S_SEARCH;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            shift_reg <= 4'b0000;
            delay_val <= 4'b0000;
            bit_cnt <= 0;
            cycle_cnt <= 999;
            current_count <= 0;
        end else begin
            state <= next_state;
            case (state)
                S_SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                end
                S_READ_DELAY: begin
                    if (bit_cnt < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        current_count <= delay_val;
                        cycle_cnt <= 999;
                    end
                end
                S_COUNTING: begin
                    if (cycle_cnt > 0) begin
                        cycle_cnt <= cycle_cnt - 1;
                    end else begin
                        cycle_cnt <= 999;
                        current_count <= current_count - 1;
                    end
                end
                S_DONE: begin
                    shift_reg <= 4'b0000;
                    bit_cnt <= 0;
                end
            endcase
        end
    end

    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);
    assign count = (state == S_COUNTING) ? current_count : 4'b0;

endmodule
