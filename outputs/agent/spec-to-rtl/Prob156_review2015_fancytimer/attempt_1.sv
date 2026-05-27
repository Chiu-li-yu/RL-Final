module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    typedef enum logic [3:0] {
        S_SEARCH,
        S_READ_DELAY,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] pattern_reg;
    logic [3:0] delay_reg;
    logic [3:0] shift_cnt;
    logic [15:0] timer_cnt;
    logic [3:0] timer_1000_cnt;

    always @(*) begin
        next_state = state;
        case (state)
            S_SEARCH: begin
                if (pattern_reg == 4'b1101) next_state = S_READ_DELAY;
            end
            S_READ_DELAY: begin
                if (shift_cnt == 4'd4) next_state = S_COUNTING;
            end
            S_COUNTING: begin
                if (timer_1000_cnt == 4'd0 && timer_cnt == 16'd0) next_state = S_DONE;
            end
            S_DONE: begin
                if (ack) next_state = S_SEARCH;
            end
            default: next_state = S_SEARCH;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern_reg <= 4'b0000;
            delay_reg <= 4'b0000;
            shift_cnt <= 4'b0000;
            timer_cnt <= 16'b0;
            timer_1000_cnt <= 4'b0;
        end else begin
            state <= next_state;
            case (state)
                S_SEARCH: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end
                S_READ_DELAY: begin
                    if (shift_cnt < 4'd4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        shift_cnt <= shift_cnt + 1'b1;
                    end else begin
                        timer_1000_cnt <= delay_reg;
                        timer_cnt <= 16'd999;
                    end
                end
                S_COUNTING: begin
                    if (timer_cnt > 0) begin
                        timer_cnt <= timer_cnt - 1'b1;
                    end else begin
                        if (timer_1000_cnt > 0) begin
                            timer_1000_cnt <= timer_1000_cnt - 1'b1;
                            timer_cnt <= 16'd999;
                        end
                    end
                end
                S_DONE: begin
                    shift_cnt <= 4'b0;
                    pattern_reg <= 4'b0;
                end
            endcase
        end
    end

    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);
    assign count = (state == S_COUNTING) ? timer_1000_cnt : 4'b0;

endmodule
