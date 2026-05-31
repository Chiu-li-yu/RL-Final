module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // States:
    // 0: Initial / last was 0
    // 1-6: saw 1, 2, 3, 4, 5, 6 consecutive 1s
    // 7: saw 7+ consecutive 1s
    // Results (in next cycle): S_DISC, S_FLAG, S_ERR
    typedef enum logic [3:0] {
        IDLE = 0, C1 = 1, C2 = 2, C3 = 3, C4 = 4, C5 = 5, C6 = 6, C7 = 7,
        S_DISC = 8, S_FLAG = 9, S_ERR = 10
    } state_t;

    state_t state, next_state;

    always @(*) begin
        next_state = IDLE;
        case (state)
            IDLE: next_state = in ? C1 : IDLE;
            C1:   next_state = in ? C2 : IDLE;
            C2:   next_state = in ? C3 : IDLE;
            C3:   next_state = in ? C4 : IDLE;
            C4:   next_state = in ? C5 : IDLE;
            C5:   next_state = in ? C6 : S_DISC; // Received 0 after 5 ones
            C6:   next_state = in ? C7 : S_FLAG; // Received 0 after 6 ones
            C7:   next_state = in ? C7 : S_ERR;  // Error on 0 after 7+
            S_DISC: next_state = in ? C1 : IDLE;
            S_FLAG: next_state = in ? C1 : IDLE;
            S_ERR:  next_state = in ? C7 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            disc <= (next_state == S_DISC);
            flag <= (next_state == S_FLAG);
            err <= (next_state == S_ERR);
        end
    end
endmodule