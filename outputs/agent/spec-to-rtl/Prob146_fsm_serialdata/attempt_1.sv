module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
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
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;
            if (state == START) begin
                shift_reg <= 8'b0;
                bit_cnt <= 3'b0;
                done <= 1'b0;
            end else if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1'b1;
            end else if (state == STOP) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (!in) next_state = DATA; // Start bit is 0
                else next_state = IDLE;
            end
            DATA: begin
                if (bit_cnt == 3'b111) next_state = STOP;
                else next_state = DATA;
            end
            STOP: begin
                if (in) next_state = IDLE;
                else next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in) next_state = IDLE;
                else next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
