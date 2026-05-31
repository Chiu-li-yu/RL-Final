module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S_DISC, S_FLAG, S_ERR
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    always @(*) begin
        next_state = S0;
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S_DISC;
            S6: next_state = in ? S_ERR : S_FLAG;
            S_DISC: next_state = in ? S1 : S0;
            S_FLAG: next_state = in ? S1 : S0;
            S_ERR: next_state = in ? S_ERR : S0;
        endcase
    end

    assign disc = (state == S_DISC);
    assign flag = (state == S_FLAG);
    assign err  = (state == S_ERR);

endmodule
