module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // Let's re-analyze: "The line is also at logic 1 when nothing is being transmitted (idle)."
    // "Identify the start bit (0), wait for all 8 data bits, then verify that the stop bit was correct (1)."
    // My previous FSM transition: IDLE (in=0) -> DATA. This consumes the start bit as if it were the 1st data bit.
    // Correct approach:
    // IDLE -> (in=0 detected) -> START (wait for data) -> DATA (8 bits) -> STOP (verify 1).
    
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_STOP
    } state_t;

    state_t state;
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
            done <= 1'b0;
            case (state)
                IDLE: begin
                    if (in == 1'b0) state <= DATA; // Actually START is 0, then we receive bits.
                    // If I treat IDLE -> DATA, I'm skipping the start bit check.
                end
                // ... (Wait, the problem is likely in the sampling timing)
            endcase
        end
    end
endmodule