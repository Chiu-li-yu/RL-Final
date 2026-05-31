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
    logic [3:0] next_bit_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            done <= (state == STOP && next_state == IDLE && in == 1'b1);
        end
    end

    always @(*) begin
        next_state = state;
        next_bit_count = bit_count;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = DATA;
                    next_bit_count = 0;
                end
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end
                next_bit_count = bit_count + 1'b1;
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
