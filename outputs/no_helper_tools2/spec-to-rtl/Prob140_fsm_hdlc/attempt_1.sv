module TopModule (
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

    always_ff @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always_comb begin
        next_state = S_IDLE;
        case (state)
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_11 : S_IDLE;
            S_11:   next_state = in ? S_111 : S_IDLE;
            S_111:  next_state = in ? S_1111 : S_IDLE;
            S_1111: next_state = in ? S_11111 : S_IDLE;
            S_11111: next_state = in ? S_FLAG : S_DISC; // 5 ones. if 1 -> flag/err, if 0 -> disc
            S_DISC:  next_state = in ? S_1 : S_IDLE;
            S_FLAG:  next_state = in ? S_ERR : S_IDLE; // Got 6 ones. if 1 -> err
            S_ERR:   next_state = in ? S_ERR : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (next_state == S_DISC);
            flag <= (next_state == S_FLAG);
            err  <= (next_state == S_ERR);
        end
    end
endmodule
