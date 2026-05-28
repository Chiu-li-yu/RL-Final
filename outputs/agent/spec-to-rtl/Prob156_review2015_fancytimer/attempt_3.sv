module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    localparam SEARCH = 0, LOAD = 1, COUNT = 2, DONE_STATE = 3;
    logic [1:0] state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] bit_counter;
    logic [3:0] delay_val;
    logic [9:0] clk_counter;
    logic [3:0] current_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 0;
            bit_counter <= 0;
            delay_val <= 0;
            clk_counter <= 0;
            current_count <= 0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                end
                LOAD: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 2) delay_val <= {shift_reg[2:0], data};
                end
                COUNT: begin
                    if (clk_counter == 10'd999) begin
                        clk_counter <= 0;
                        if (current_count > 0) current_count <= current_count - 1;
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
        count = current_count;

        case (state)
            SEARCH: begin
                if (shift_reg == 4'b1101) next_state = LOAD;
            end
            LOAD: begin
                if (bit_counter == 3) next_state = COUNT;
            end
            COUNT: begin
                counting = 1;
                if (clk_counter == 10'd999 && current_count == 0) next_state = DONE_STATE;
            end
            DONE_STATE: begin
                done = 1;
                if (ack) next_state = SEARCH;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) current_count <= 0;
        else if (state == LOAD && bit_counter == 3) current_count <= {shift_reg[2:0], data};
    end
endmodule
