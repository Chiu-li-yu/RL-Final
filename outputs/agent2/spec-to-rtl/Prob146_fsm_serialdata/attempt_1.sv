module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // UART protocol: Idle(1) -> Start(0) -> 8 Data (LSB first) -> Stop(1)
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_STOP // If stop bit was 0
    } state_t;

    state_t state, next_state;
    logic [2:0] bit_cnt;
    logic [7:0] shift_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
            done <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1;
            end else if (state == START) begin
                bit_cnt <= 0;
            end
            
            if (state == STOP && in == 1'b1) begin
                done <= 1;
                out_byte <= shift_reg;
            end else begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_cnt == 7) ? STOP : DATA;
            STOP: begin
                if (in == 1) next_state = IDLE;
                else next_state = WAIT_STOP;
            end
            WAIT_STOP: next_state = (in == 1) ? IDLE : WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end
endmodule
