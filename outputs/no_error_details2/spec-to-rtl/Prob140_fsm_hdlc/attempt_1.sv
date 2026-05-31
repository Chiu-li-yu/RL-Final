module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7,
        S_DISC = 8, S_FLAG = 9, S_ERR = 10
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
            S5: next_state = in ? S6 : S_DISC;
            S6: next_state = in ? S7 : S_FLAG;
            S7: next_state = in ? S7 : S_ERR; // Wait, S7 means 7+ ones
            S_DISC: next_state = in ? S1 : S0;
            S_FLAG: next_state = in ? S1 : S0;
            S_ERR: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    always @(posedge clk) begin
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