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
        WAIT_IDLE
    } state_t;

    logic [2:0] state, next_state;
    logic [3:0] bit_cnt;
    logic done_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            if (state == START) begin
                bit_cnt <= 0;
            end else if (state == DATA) begin
                bit_cnt <= bit_cnt + 1;
            end
            
            if (state == STOP && in == 1'b1 && next_state == IDLE)
                done_reg <= 1'b1;
            else
                done_reg <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA; // Assuming sampling at bit speed
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_cnt == 4'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
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
                else
                    next_state = WAIT_IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule
