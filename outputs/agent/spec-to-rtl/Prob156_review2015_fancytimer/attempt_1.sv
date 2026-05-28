module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    localparam SEARCH = 0, LOAD_DELAY = 1, COUNTING = 2, DONE_STATE = 3;
    logic [1:0] state, next_state;
    logic [3:0] delay_val, current_delay;
    logic [3:0] shift_reg;
    logic [2:0] shift_idx;
    logic [10:0] clk_counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 0;
            shift_idx <= 0;
            delay_val <= 0;
            current_delay <= 0;
            clk_counter <= 0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    if (data) shift_reg <= {shift_reg[2:0], 1'b1};
                    else shift_reg <= {shift_reg[2:0], 1'b0};
                    
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin
                        shift_idx <= 0;
                    end
                end
                LOAD_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    shift_idx <= shift_idx + 1;
                    if (shift_idx == 3) delay_val <= {shift_reg[2:0], data};
                end
                COUNTING: begin
                    if (clk_counter == 1000) begin
                        clk_counter <= 0;
                        if (current_delay == 0) begin
                        end else begin
                            current_delay <= current_delay - 1;
                        end
                    end else begin
                        clk_counter <= clk_counter + 1;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        counting = 0;
        done = 0;
        count = current_delay;

        case (state)
            SEARCH: begin
                if (shift_reg == 4'b1101) next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (shift_idx == 3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                counting = 1;
                if (clk_counter == 1000 && current_delay == 0) next_state = DONE_STATE;
            end
            DONE_STATE: begin
                done = 1;
                if (ack) next_state = SEARCH;
            end
        endcase
    end
endmodule
