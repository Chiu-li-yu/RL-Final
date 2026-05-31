module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // State definitions
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_STOP
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;
            if (state == START) begin
                bit_cnt <= 3'b0;
            end else if (state == DATA) begin
                shift_reg[bit_cnt] <= in;
                bit_cnt <= bit_cnt + 1'b1;
            end else if (state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'd7) next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1) next_state = IDLE;
            end
        endcase
    end
endmodule