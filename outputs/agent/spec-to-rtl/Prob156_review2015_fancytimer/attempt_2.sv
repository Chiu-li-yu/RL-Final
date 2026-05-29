
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input  ack
);

    localparam SEARCH    = 2'd0;
    localparam GET_DELAY = 2'd1;
    localparam COUNTING  = 2'd2;
    localparam DONE      = 2'd3;

    logic [1:0] state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [2:0] bit_count;
    logic [9:0] cycle_count;
    logic [3:0] current_delay;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_count <= 3'b0;
            cycle_count <= 10'b0;
            current_delay <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if ({shift_reg[2:0], data} == 4'b1101) begin
                        state <= GET_DELAY;
                        bit_count <= 3'b0;
                        delay_val <= 4'b0;
                    end
                end

                GET_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    if (bit_count == 3'd3) begin
                        state <= COUNTING;
                        current_delay <= {delay_val[2:0], data};
                        cycle_count <= 10'b0;
                    end else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end

                COUNTING: begin
                    cycle_count <= cycle_count + 1'b1;
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'b0;
                        if (current_delay == 4'b0) begin
                            state <= DONE;
                        end else begin
                            current_delay <= current_delay - 1'b1;
                        end
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= SEARCH;
                        shift_reg <= 4'b0;
                    end
                end
                default: state <= SEARCH;
            endcase
        end
    end

    always_comb begin
        counting = (state == COUNTING);
        done = (state == DONE);
        if (state == COUNTING) begin
            count = current_delay;
        end else begin
            count = 4'b0;
        end
    end

endmodule
