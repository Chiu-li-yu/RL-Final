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
        IDLE, SHIFT_DELAY, COUNTING, WAIT_ACK
    } state_t;

    state_t state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] shift_cnt;
    logic [3:0] delay_val;
    logic [3:0] current_count;
    logic [9:0] inner_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_cnt <= 3'b0;
            delay_val <= 4'b0;
            inner_cnt <= 10'b0;
            current_count <= 4'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        shift_cnt <= 3'd3;
                    end
                end
                SHIFT_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_cnt > 0) shift_cnt <= shift_cnt - 1;
                end
                COUNTING: begin
                    if (inner_cnt == 10'd999) begin
                        inner_cnt <= 10'b0;
                        if (current_count > 0) current_count <= current_count - 1;
                    end else begin
                        inner_cnt <= inner_cnt + 1;
                    end
                end
            endcase
            if (state == SHIFT_DELAY && shift_cnt == 0) begin
                delay_val <= {shift_reg[2:0], data};
                current_count <= {shift_reg[2:0], data};
            end
        end
    end

    always @(*) begin
        next_state = state;
        counting = 1'b0;
        done = 1'b0;
        count = current_count;

        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) next_state = SHIFT_DELAY;
            end
            SHIFT_DELAY: begin
                if (shift_cnt == 0) next_state = COUNTING;
            end
            COUNTING: begin
                counting = 1'b1;
                if (current_count == 0 && inner_cnt == 10'd999) next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
        endcase
    end
endmodule