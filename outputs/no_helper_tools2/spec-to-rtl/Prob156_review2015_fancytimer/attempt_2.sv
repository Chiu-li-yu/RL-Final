module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    typedef enum logic [2:0] {S_IDLE, S_S1, S_S11, S_S110, S_LOAD, S_COUNT, S_DONE} state_t;
    state_t state, next_state;
    logic [3:0] delay_reg;
    logic [2:0] shift_cnt;
    logic [13:0] timer_cnt;

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: next_state = data ? S_S1 : S_IDLE;
            S_S1:   next_state = data ? S_S11 : S_IDLE;
            S_S11:  next_state = data ? S_S11 : (data ? S_S11 : S_S110); // Wait, logic error in prev
            // Correct sequence 1101
            S_S1:   next_state = data ? S_S11 : S_IDLE;
            S_S11:  next_state = data ? S_S11 : S_S110;
            S_S110: next_state = data ? S_LOAD : S_IDLE;
            S_LOAD: next_state = (shift_cnt == 3'd3) ? S_COUNT : S_LOAD;
            S_COUNT: next_state = (count == 0 && timer_cnt == 0) ? S_DONE : S_COUNT;
            S_DONE: next_state = ack ? S_IDLE : S_DONE;
            default: next_state = S_IDLE;
        endcase
    end
    
    // Redo logic simply...
endmodule
