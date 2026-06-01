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
        WAIT_STOP
    } state_t;

    state_t state, next_state;
    logic [3:0] bit_cnt;
    logic [7:0] data_reg;
    logic done_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            data_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                bit_cnt <= bit_cnt + 1;
                data_reg[bit_cnt] <= in;
            end else if (state == IDLE || state == STOP) begin
                bit_cnt <= 0;
            end
            
            if (state == STOP && in == 1'b1) begin
                done_reg <= 1'b1;
            end else begin
                done_reg <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 4'd7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule