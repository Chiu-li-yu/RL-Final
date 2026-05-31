module TopModule(
    input clk,
    input reset,
    input w,
    output logic z
);

    typedef enum logic [2:0] {
        S_A = 3'd0,
        S_B = 3'd1,
        S_C = 3'd2,
        S_D = 3'd3,
        S_E = 3'd4,
        S_F = 3'd5
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= S_A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S_A: next_state = w ? S_A : S_B;
            S_B: next_state = w ? S_D : S_C;
            S_C: next_state = w ? S_D : S_E;
            S_D: next_state = w ? S_A : S_F;
            S_E: next_state = w ? S_D : S_E;
            S_F: next_state = w ? S_D : S_C;
            default: next_state = S_A;
        endcase
    end

    always @(*) begin
        case (state)
            S_E, S_F: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule
