module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    typedef enum logic [3:0] {
        IDLE,
        SHIFT_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] bit_cnt;
    logic [3:0] delay_val;
    logic [9:0] cycle_cnt;
    logic [3:0] current_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            bit_cnt <= 3'b0;
            delay_val <= 4'b0;
            cycle_cnt <= 10'd0;
            current_count <= 4'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if ({shift_reg[2:0], data} == 4'b1101) begin
                        bit_cnt <= 3'd0;
                    end
                end
                SHIFT_DELAY: begin
                    if (bit_cnt < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_cnt <= bit_cnt + 1;
                    end
                end
                COUNTING: begin
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        current_count <= current_count - 1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end
                DONE: begin
                    // Wait for ack
                end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        counting = 1'b0;
        done = 1'b0;
        count = current_count;

        case (state)
            IDLE: begin
                if ({shift_reg[2:0], data} == 4'b1101)
                    next_state = SHIFT_DELAY;
            end
            SHIFT_DELAY: begin
                if (bit_cnt == 3'd4) begin
                    next_state = COUNTING;
                    // Logic to load delay_val done in FF
                end
            end
            COUNTING: begin
                counting = 1'b1;
                if (current_count == 4'b0 && cycle_cnt == 10'd999)
                    next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Separate logic to handle initialization for COUNTING
    always_ff @(posedge clk) begin
        if (reset) begin
            current_count <= 4'd0;
        end else if (state == SHIFT_DELAY && bit_cnt == 3'd4) begin
            current_count <= delay_val;
        end
    end

endmodule