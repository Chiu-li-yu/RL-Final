module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // States: One-hot encoding
    // A = 2'b01
    // B = 2'b10
    logic [1:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            2'b01: next_state = (x) ? 2'b10 : 2'b01;
            2'b10: next_state = 2'b10;
            default: next_state = 2'b01;
        endcase
    end

    // Mealy Output: z depends on state and input x
    assign z = (state == 2'b01 && x == 1'b1) || (state == 2'b10 && x == 1'b0);

endmodule
