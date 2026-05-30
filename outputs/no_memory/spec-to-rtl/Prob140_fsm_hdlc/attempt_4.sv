module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S_IDLE,
        S_1, S_2, S_3, S_4, S_5,
        S_6, S_7,
        S_DISC, S_FLAG, S_ERR
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        disc = 0;
        flag = 0;
        err = 0;

        case (state)
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_2 : S_IDLE;
            S_2:    next_state = in ? S_3 : S_IDLE;
            S_3:    next_state = in ? S_4 : S_IDLE;
            S_4:    next_state = in ? S_5 : S_IDLE;
            S_5:    next_state = in ? S_6 : S_DISC; // 0111110 detected
            S_6:    next_state = in ? S_7 : S_FLAG; // 01111110 detected
            S_7:    next_state = in ? S_7 : S_ERR;  // 7+ detected

            S_DISC: begin
                disc = 1;
                next_state = in ? S_1 : S_IDLE;
            end
            S_FLAG: begin
                flag = 1;
                next_state = in ? S_1 : S_IDLE;
            end
            S_ERR: begin
                err = 1;
                next_state = in ? S_1 : S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end
endmodule