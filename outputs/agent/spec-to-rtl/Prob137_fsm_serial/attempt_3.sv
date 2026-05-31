module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic done
);

    // Protocol: Start (0) + 8 data bits + Stop (1)
    // The problem asks to identify the start bit, collect 8 bits, then verify stop bit.
    // The sample time for each bit is every cycle.
    
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_STOP
    } state_t;

    state_t state, next_state;
    logic [3:0] bit_cnt;
    logic done_q;

    // FSM State Register
    always_ff @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // bit_cnt tracking
    always_ff @(posedge clk) begin
        if (reset)
            bit_cnt <= 0;
        else if (state == START)
            bit_cnt <= 0;
        else if (state == DATA)
            bit_cnt <= bit_cnt + 1;
    end

    // FSM Transition Logic
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
                next_state = IDLE; // Verification happens after this state transition
            WAIT_STOP:
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: verify the stop bit exactly after 8th data bit
    // According to specs: verify the stop bit was correct. If not, wait.
    always_ff @(posedge clk) begin
        if (reset)
            done_q <= 1'b0;
        else if (state == STOP && in == 1'b1)
            done_q <= 1'b1;
        else
            done_q <= 1'b0;
    end

    assign done = done_q;

endmodule