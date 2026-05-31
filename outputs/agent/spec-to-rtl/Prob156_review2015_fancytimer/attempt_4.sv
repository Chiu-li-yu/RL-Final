
module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

    localparam SEARCH   = 2'd0;
    localparam GET_BITS = 2'd1;
    localparam COUNTING = 2'd2;
    localparam FINISHED = 2'd3;

    logic [1:0] state;
    logic [3:0] pattern_reg;
    logic [3:0] delay_reg;
    logic [1:0] bit_cnt;
    logic [9:0] timer_inner;
    logic [3:0] timer_outer;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_cnt <= 2'b0;
            timer_inner <= 10'b0;
            timer_outer <= 4'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if ({pattern_reg[2:0], data} == 4'b1101) begin
                        state <= GET_BITS;
                        bit_cnt <= 2'b0;
                        delay_reg <= 4'b0;
                    end
                end
                GET_BITS: begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (bit_cnt == 2'd3) begin
                        state <= COUNTING;
                        timer_inner <= 10'b0;
                        timer_outer <= {delay_reg[2:0], data};
                        count <= {delay_reg[2:0], data};
                        bit_cnt <= 2'b0;
                    end else begin
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                end
                COUNTING: begin
                    if (timer_inner == 10'd999) begin
                        timer_inner <= 10'b0;
                        if (timer_outer == 4'd0) begin
                            state <= FINISHED;
                        end else begin
                            timer_outer <= timer_outer - 4'd1;
                            count <= timer_outer - 4'd1;
                        end
                    end else begin
                        timer_inner <= timer_inner + 10'd1;
                    end
                end
                FINISHED: begin
                    if (ack) begin
                        state <= SEARCH;
                    end
                end
                default: state <= SEARCH;
            endcase
        end
    end

    always @(*) begin
        counting = (state == COUNTING);
        done = (state == FINISHED);
    end

endmodule
