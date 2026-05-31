module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_FOR_STOP
    } state_t;

    state_t state, next_state;
    logic [2:0] bit_cnt;
    logic [2:0] next_bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            bit_cnt <= next_bit_cnt;
            done <= (state == STOP && in == 1'b1);
        end
    end

    always_comb begin
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
                if (bit_cnt == 7) begin
                    next_state = STOP;
                    next_bit_cnt = 0;
                end else begin
                    next_bit_cnt = bit_cnt + 1;
                end
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_FOR_STOP;
            end
            WAIT_FOR_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule