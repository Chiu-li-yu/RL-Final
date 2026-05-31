module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    logic state, next_state;

    // States: S0 (waiting for first '1'), S1 (flipping bits)
    parameter S0 = 1'b0;
    parameter S1 = 1'b1;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

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
            S0: z = x; // When x=0, z=0. When x=1 (first one), z=1.
            S1: z = ~x; // After first '1', flip the bits.
            default: z = 1'b0;
        endcase
    end

endmodule
