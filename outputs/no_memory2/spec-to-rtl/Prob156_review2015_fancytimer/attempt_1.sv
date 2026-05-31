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
        DETECT_1,
        DETECT_11,
        DETECT_110,
        DETECT_1101,
        SHIFT_DELAY,
        COUNTING,
        WAIT_ACK
    } state_t;

    state_t state, next_state;
    logic [3:0] delay_reg;
    logic [2:0] bit_counter;
    logic [9:0] cycle_counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_reg <= 4'd0;
            bit_counter <= 3'd0;
            cycle_counter <= 10'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                DETECT_1101: begin
                    bit_counter <= 3'd3;
                    delay_reg <= 4'd0;
                end
                SHIFT_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter - 1'b1;
                end
                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (count > 0)
                            count <= count - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end
                WAIT_ACK: begin
                    if (ack) begin
                        done <= 1'b0;
                        counting <= 1'b0;
                    end
                end
                default: ;
            endcase

            if (state == SHIFT_DELAY && bit_counter == 3'd0) begin
                counting <= 1'b1;
                count <= {delay_reg[2:0], data};
                cycle_counter <= 10'd0;
            end
            
            if (state == COUNTING && cycle_counter == 10'd999 && count == 4'd0) begin
                counting <= 1'b0;
                done <= 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:        next_state = (data) ? DETECT_1 : IDLE;
            DETECT_1:    next_state = (data) ? DETECT_11 : IDLE;
            DETECT_11:   next_state = (data) ? DETECT_11 : DETECT_110;
            DETECT_110:  next_state = (data) ? DETECT_1101 : IDLE;
            DETECT_1101: next_state = SHIFT_DELAY;
            SHIFT_DELAY: next_state = (bit_counter == 0) ? COUNTING : SHIFT_DELAY;
            COUNTING:    next_state = (count == 0 && cycle_counter == 10'd999) ? WAIT_ACK : COUNTING;
            WAIT_ACK:    next_state = (ack) ? IDLE : WAIT_ACK;
        endcase
    end
endmodule