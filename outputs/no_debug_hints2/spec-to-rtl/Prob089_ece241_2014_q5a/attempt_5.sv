module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    typedef enum logic [1:0] { S0, S1, S2 } state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) current_state <= S0;
        else current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S2 : S1;
            S2: next_state = (x) ? S2 : S1;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        case (current_state)
            S0: z = 1'b0;
            S1: z = 1'b1;
            S2: z = 1'b0;
            default: z = 1'b0;
        endcase
    end
endmodule
