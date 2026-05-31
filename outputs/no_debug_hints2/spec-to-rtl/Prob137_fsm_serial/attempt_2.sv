module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);
    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        WAIT_IDLE = 3'd4
    } state_t;

    state_t state, next_state;
    logic [3:0] bit_cnt, next_bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            bit_cnt <= next_bit_cnt;
            if (state == STOP && in == 1'b1 && next_state == IDLE)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        next_bit_cnt = bit_cnt;
        
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
                next_bit_cnt = 0;
            end
            DATA: begin
                if (bit_cnt == 4'd7)
                    next_state = STOP;
                else
                    next_bit_cnt = bit_cnt + 1'b1;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_IDLE;
            end
            WAIT_IDLE: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
