module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_IDLE
    } state_t;

    state_t state, next_state;
    logic [2:0] bit_count;
    logic [2:0] next_bit_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            
            // done only high for 1 cycle when valid byte received
            if (state == STOP && in == 1 && next_state == IDLE)
                done <= 1;
            else
                done <= 0;
        end
    end

    always_comb begin
        next_state = state;
        next_bit_count = bit_count;

        case (state)
            IDLE: begin
                if (in == 0)
                    next_state = DATA;
            end
            DATA: begin
                if (bit_count == 7) begin
                    next_state = STOP;
                    next_bit_count = 0;
                end else begin
                    next_bit_count = bit_count + 1;
                end
            end
            STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_IDLE;
            end
            WAIT_IDLE: begin
                if (in == 1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
