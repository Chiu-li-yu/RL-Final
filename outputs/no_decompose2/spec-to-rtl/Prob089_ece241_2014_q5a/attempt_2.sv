module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    logic state, next_state;

    // Moore State Machine
    // S0: No 1s encountered yet (0s stay 0s, first 1 stays 1)
    // S1: 1 encountered (all bits flipped)
    parameter S0 = 1'b0;
    parameter S1 = 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                next_state = (x) ? S1 : S0;
            end
            S1: begin
                next_state = S1;
            end
            default: next_state = S0;
        endcase
    end

    // Moore machine: z depends only on state
    assign z = (state == S0) ? x : ~x;
endmodule
