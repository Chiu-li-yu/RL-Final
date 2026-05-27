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
        S1,
        S11,
        S111,
        S1111,
        S11111,
        S111111,
        S_DISC_STATE,
        S_FLAG_STATE,
        S_ERR_STATE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE:    next_state = in ? S1 : IDLE;
            S1:      next_state = in ? S11 : IDLE;
            S11:     next_state = in ? S111 : IDLE;
            S111:    next_state = in ? S1111 : IDLE;
            S1111:   next_state = in ? S11111 : IDLE;
            S11111:  next_state = in ? S111111 : S_DISC_STATE;
            S111111: next_state = in ? S_ERR_STATE : S_FLAG_STATE;
            S_DISC_STATE: next_state = in ? S1 : IDLE;
            S_FLAG_STATE: next_state = in ? S1 : IDLE;
            S_ERR_STATE:  next_state = in ? S_ERR_STATE : IDLE;
            default:      next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (next_state == S_DISC_STATE);
            flag <= (next_state == S_FLAG_STATE);
            err  <= (next_state == S_ERR_STATE);
        end
    end

endmodule
