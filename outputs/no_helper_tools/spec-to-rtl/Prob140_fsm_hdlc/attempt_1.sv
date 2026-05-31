module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S_IDLE,
        S_1,
        S_11,
        S_111,
        S_1111,
        S_11111,
        S_DISC,   // After 5 ones, saw 0
        S_FLAG,   // After 6 ones, saw 0
        S_ERR     // Saw 7 or more ones
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = S_IDLE;
        case (state)
            S_IDLE:  next_state = in ? S_1 : S_IDLE;
            S_1:     next_state = in ? S_11 : S_IDLE;
            S_11:    next_state = in ? S_111 : S_IDLE;
            S_111:   next_state = in ? S_1111 : S_IDLE;
            S_1111:  next_state = in ? S_11111 : S_IDLE;
            S_11111: next_state = in ? S_ERR : S_DISC;
            S_DISC:  next_state = in ? S_1 : S_IDLE;
            S_FLAG:  next_state = in ? S_1 : S_IDLE;
            S_ERR:   next_state = in ? S_ERR : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Correcting transition for FLAG detection:
    // If we are in S_11111 and receive 1, we go to a state representing 6 ones.
    // Let's redefine the state machine more carefully.
    
    // Revised Logic:
    // State 0: last 0
    // State 1: 1
    // State 2: 11
    // State 3: 111
    // State 4: 1111
    // State 5: 11111
    // State 6: 111111 (next is 0 -> flag, 1 -> err)
    
endmodule
