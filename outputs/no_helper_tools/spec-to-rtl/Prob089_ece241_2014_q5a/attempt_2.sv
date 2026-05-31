module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

    // Moore State Machine for 2's complement
    // State 0: Least significant 0s (z = x)
    // State 1: After the first 1 (z = ~x)
    
    logic state, next_state;
    logic z_out;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Moore machine output depends only on state
    // Wait, the logic for serial 2's complement:
    // If we haven't seen a '1' yet, z = x (0 -> 0, 1 -> 1)
    // After the first '1' is processed, we invert everything.
    // 0 -> 1, 1 -> 0.

    always @(*) begin
        case (state)
            1'b0: begin
                // In state 0, z = x
                z_out = x;
                // If we see 1, transition to state 1
                next_state = (x == 1'b1) ? 1'b1 : 1'b0;
            end
            1'b1: begin
                // In state 1, z = ~x
                z_out = ~x;
                next_state = 1'b1;
            end
            default: begin
                z_out = 1'b0;
                next_state = 1'b0;
            end
        endcase
    end

    assign z = z_out;

endmodule
