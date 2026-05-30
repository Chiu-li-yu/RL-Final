module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        IDLE,
        S_0,
        S_01,
        S_011,
        S_0111,
        S_01111,
        S_011111, // 5 ones
        S_DISC,   // After 0111110
        S_FLAG,   // After 01111110
        S_ERR     // After 01111111...
    } state_t;

    state_t state, next_state;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:    next_state = in ? S_01 : S_0; // Wait for initial 0
            S_0:     next_state = in ? S_01 : S_0;
            S_01:    next_state = in ? S_011 : S_0;
            S_011:   next_state = in ? S_0111 : S_0;
            S_0111:  next_state = in ? S_01111 : S_0;
            S_01111: next_state = in ? S_011111 : S_0;
            S_011111: next_state = in ? S_ERR : S_DISC; // 011111 + 1 (err) or 0 (disc)
            S_DISC:  next_state = in ? S_01 : S_0;
            S_FLAG:  next_state = in ? S_01 : S_0;
            S_ERR:   next_state = in ? S_ERR : S_0;
            default: next_state = S_0;
        endcase
    end

    // Need to detect 01111110 specifically for flag
    // Corrected FSM logic to distinguish 0111110 vs 01111110
    // Let's refine the states
    // IDLE/S_0 (initial)
    // S_1 (1)
    // S_11 (11)
    // S_111 (111)
    // S_1111 (1111)
    // S_11111 (11111)
    // S_111110 (111110) -> DISC
    // S_1111110 (1111110) -> FLAG
    // S_1111111 (1111111) -> ERR
endmodule
