module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);

    typedef enum logic {S0, S1} state_t;
    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (x == 1'b1) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            S0: z = x;
            S1: z = ~x;
            default: z = 1'b0;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule
