module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S_IDLE, S_1, S_11, S_111, S_1111, S_11111, S_DISC, S_FLAG, S_ERR
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_11 : S_IDLE;
            S_11:   next_state = in ? S_111 : S_IDLE;
            S_111:  next_state = in ? S_1111 : S_IDLE;
            S_1111: next_state = in ? S_11111 : S_IDLE;
            S_11111: next_state = in ? S_ERR : S_DISC; // 0111111 -> ERR, 0111110 -> DISC
            S_DISC: next_state = in ? S_1 : S_IDLE;
            S_FLAG: next_state = in ? S_1 : S_IDLE;
            S_ERR:  next_state = in ? S_ERR : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    always @(*) begin
        disc = (state == S_DISC);
        flag = (state == S_FLAG);
        err  = (state == S_ERR);
    end

endmodule