module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    typedef enum logic { S0, S1 } state_t;
    state_t current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Combinational logic for output
    always @(*) begin
        case (current_state)
            S0: z = x;
            S1: z = !x;
            default: z = 0;
        endcase
    end
endmodule
