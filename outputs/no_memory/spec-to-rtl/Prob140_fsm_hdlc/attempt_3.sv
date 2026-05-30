module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S_IDLE = 4'd0,
        S_1    = 4'd1,
        S_11   = 4'd2,
        S_111  = 4'd3,
        S_1111 = 4'd4,
        S_11111= 4'd5,
        S_DISC = 4'd6,
        S_111111= 4'd7,
        S_FLAG = 4'd8,
        S_ERR  = 4'd9
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_11 : S_IDLE;
            S_11:   next_state = in ? S_111 : S_IDLE;
            S_111:  next_state = in ? S_1111 : S_IDLE;
            S_1111: next_state = in ? S_11111 : S_IDLE;
            S_11111: next_state = in ? S_111111 : S_IDLE; // 0111110 -> S_IDLE by logic in S_11111 ? no.
            // Correcting logic:
            // S_11111 + in=0 -> DISC
            // S_11111 + in=1 -> S_111111
            // S_111111 + in=0 -> FLAG
            // S_111111 + in=1 -> ERR
        endcase
    end

    // Refined logic
    always_comb begin
        case (state)
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_11 : S_IDLE;
            S_11:   next_state = in ? S_111 : S_IDLE;
            S_111:  next_state = in ? S_1111 : S_IDLE;
            S_1111: next_state = in ? S_11111 : S_IDLE;
            S_11111: next_state = in ? S_111111 : S_DISC;
            S_111111: next_state = in ? S_ERR : S_FLAG;
            S_DISC: next_state = in ? S_1 : S_IDLE;
            S_FLAG: next_state = in ? S_1 : S_IDLE;
            S_ERR:  next_state = in ? S_ERR : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    always_comb begin
        disc = (state == S_DISC);
        flag = (state == S_FLAG);
        err = (state == S_ERR);
    end

endmodule