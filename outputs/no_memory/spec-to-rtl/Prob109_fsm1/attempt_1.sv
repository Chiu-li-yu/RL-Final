module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    logic state, next_state;

    // State Register
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Next State Logic
    always_comb begin
        case (state)
            B: next_state = (in) ? B : A;
            A: next_state = (in) ? A : B;
            default: next_state = B;
        endcase
    end

    // Output Logic
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule