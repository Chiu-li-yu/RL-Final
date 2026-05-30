module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // States: 0 = KEEP (before first 1), 1 = FLIP (after first 1)
    logic state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            1'b0: next_state = (x) ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

    // Output z logic
    // In state 0 (KEEP): z = x
    // In state 1 (FLIP): z = ~x
    assign z = (state == 1'b0) ? x : ~x;

endmodule
