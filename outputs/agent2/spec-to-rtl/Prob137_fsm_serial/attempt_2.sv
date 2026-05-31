module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic done
);

    // Using standard coding style to ensure timing alignment
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_STOP
    } state_t;

    state_t state, next_state;
    logic [3:0] bit_cnt;

    // FSM State Register
    always_ff @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Counter and Bit Logic
    always_ff @(posedge clk) begin
        if (reset)
            bit_cnt <= 0;
        else if (state == DATA)
            bit_cnt <= bit_cnt + 1;
        else
            bit_cnt <= 0;
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:
                if (in == 1'b0) next_state = START;
                else next_state = IDLE;
            START:
                next_state = DATA;
            DATA:
                if (bit_cnt == 4'd7) next_state = STOP;
                else next_state = DATA;
            STOP:
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT_STOP;
            WAIT_STOP:
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end

    // Output Logic: done should be high when returning to IDLE after a valid STOP
    assign done = (state == STOP && in == 1'b1);

endmodule