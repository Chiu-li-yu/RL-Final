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
        WAIT_STOP
    } state_t;

    state_t state, next_state;
    logic [3:0] bit_count;
    logic [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1;
            end else if (state == IDLE || state == STOP) begin
                bit_count <= 0;
            end
            
            if (next_state == IDLE && state == STOP && in == 1)
                done <= 1;
            else
                done <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule