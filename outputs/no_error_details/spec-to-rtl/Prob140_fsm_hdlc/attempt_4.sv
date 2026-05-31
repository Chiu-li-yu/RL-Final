module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // Using Moore FSM states
    typedef enum logic [3:0] {
        IDLE, S1, S2, S3, S4, S5, S6, S7_PLUS, S_DISC, S_FLAG, S_ERR
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            IDLE:    next_state = (in) ? S1 : IDLE;
            S1:      next_state = (in) ? S2 : IDLE;
            S2:      next_state = (in) ? S3 : IDLE;
            S3:      next_state = (in) ? S4 : IDLE;
            S4:      next_state = (in) ? S5 : IDLE;
            S5:      next_state = (in) ? S6 : S_DISC; // 0111110
            S6:      next_state = (in) ? S7_PLUS : S_FLAG; // 01111110
            S7_PLUS: next_state = (in) ? S7_PLUS : S_ERR; // 0111111...
            S_DISC:  next_state = (in) ? S1 : IDLE;
            S_FLAG:  next_state = (in) ? S1 : IDLE;
            S_ERR:   next_state = (in) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Moore outputs: state is the result
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (next_state == S_DISC);
            flag <= (next_state == S_FLAG);
            err <= (next_state == S_ERR);
        end
    end

endmodule
