module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    typedef enum logic [2:0] {
        SEARCH, GET_DELAY, COUNTING, WAIT_ACK
    } state_t;

    state_t state, next_state;
    logic [3:0] shift_reg;
    logic [2:0] bit_cnt;
    logic [3:0] delay_val;
    logic [9:0] cycle_cnt;
    logic [3:0] remaining;

    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (shift_reg == 4'b1101) next_state = GET_DELAY;
            end
            GET_DELAY: begin
                if (bit_cnt == 4) next_state = COUNTING;
            end
            COUNTING: begin
                if (remaining == 0 && cycle_cnt == 999) next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack) next_state = SEARCH;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 0;
            bit_cnt <= 0;
            delay_val <= 0;
            cycle_cnt <= 0;
            remaining <= 0;
            counting <= 0;
            done <= 0;
            count <= 0;
        end else begin
            state <= next_state;
            case (state)
                SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                end
                GET_DELAY: begin
                    if (bit_cnt < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        remaining <= delay_val;
                        counting <= 1;
                        cycle_cnt <= 0;
                        bit_cnt <= 0;
                    end
                end
                COUNTING: begin
                    if (cycle_cnt == 999) begin
                        cycle_cnt <= 0;
                        if (remaining > 0) remaining <= remaining - 1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                    count <= remaining;
                end
                WAIT_ACK: begin
                    counting <= 0;
                    done <= 1;
                    shift_reg <= 0; // reset shift reg for next search
                end
            endcase
        end
    end
endmodule