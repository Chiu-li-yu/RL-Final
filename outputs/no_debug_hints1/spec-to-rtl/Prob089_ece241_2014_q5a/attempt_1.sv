module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    typedef enum logic {
        S0 = 1'b0,
        S1 = 1'b1
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            S0: next_state = (x == 1'b1) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    always_comb begin
        case (current_state)
            S0: z = x;
            S1: z = ~x;
            default: z = x;
        endcase
    end

endmodule
