module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0,      // last was 0
        S1,      // 01
        S2,      // 011
        S3,      // 0111
        S4,      // 01111
        S5,      // 011111
        S6_DISC, // 0111110 (discard)
        S6_FLAG, // 01111110 (flag)
        S7_ERR   // 01111111... (err)
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6_FLAG : S6_DISC; // in=1 -> S6_FLAG, in=0 -> S6_DISC
            S6_DISC: next_state = in ? S1 : S0;
            S6_FLAG: next_state = in ? S7_ERR : S0; // if in=1 after 01111110 -> Error
            S7_ERR: next_state = in ? S7_ERR : S0;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        disc = (current_state == S6_DISC);
        flag = (current_state == S6_FLAG);
        err  = (current_state == S7_ERR);
    end

endmodule
