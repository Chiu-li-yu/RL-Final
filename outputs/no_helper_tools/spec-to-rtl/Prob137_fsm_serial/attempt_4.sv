module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE,
        START,
        DATA_0, DATA_1, DATA_2, DATA_3, DATA_4, DATA_5, DATA_6, DATA_7,
        STOP
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: next_state = DATA_0;
            DATA_0: next_state = DATA_1;
            DATA_1: next_state = DATA_2;
            DATA_2: next_state = DATA_3;
            DATA_3: next_state = DATA_4;
            DATA_4: next_state = DATA_5;
            DATA_5: next_state = DATA_6;
            DATA_6: next_state = DATA_7;
            DATA_7: next_state = STOP;
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // "If the stop bit does not appear when expected, the FSM 
                    // must wait until it finds a stop bit before attempting 
                    // to receive the next byte."
                    // My original logic had a specific WAIT_STOP state.
                    // Let's reconsider the "IDLE" transition.
                    // The standard FSM for this problem:
                    // IDLE -> START (if in=0)
                    // START -> D0..D7 -> STOP
                    // If STOP is 1 -> DONE = 1, back to IDLE
                    // If STOP is 0 -> back to IDLE? No, it must wait.
                    // Wait, maybe the state should go back to IDLE *only* if the line is 1.
                    next_state = STOP; // Wait in STOP state until it's 1?
                end
            end
        endcase
    end
endmodule
