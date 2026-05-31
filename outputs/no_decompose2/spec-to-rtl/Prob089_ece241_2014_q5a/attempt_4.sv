module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    logic state, next_state;

    // 2's complement logic:
    // Starting from LSB, keep 0s, keep the first 1, then invert all subsequent bits.
    // Let's use a Mealy machine logic as the problem asks for Moore,
    // but Moore machines in this context usually mean the output is a register.
    // If it's a "Moore machine", z must be a register.

    logic z_reg;
    parameter S0 = 1'b0;
    parameter S1 = 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                S0: z_reg <= (x == 1'b0) ? 1'b0 : 1'b1;
                S1: z_reg <= (x == 1'b0) ? 1'b1 : 1'b0;
            endcase
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = (x == 1'b0) ? S0 : S1;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    assign z = z_reg;
endmodule
