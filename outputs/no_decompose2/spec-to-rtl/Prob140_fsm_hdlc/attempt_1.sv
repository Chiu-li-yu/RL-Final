module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, SDISC, SFLAG, SERR
    } state_t;

    state_t state, next_state;

    always @(*) begin
        next_state = state;
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? SERR : SDISC;
            SDISC: next_state = in ? S1 : S0;
            SFLAG: next_state = in ? S1 : S0;
            SERR: next_state = in ? SERR : S0;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            disc <= (next_state == SDISC);
            flag <= (next_state == SFLAG);
            err <= (next_state == SERR);
        end
    end
endmodule
