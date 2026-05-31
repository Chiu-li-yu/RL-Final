module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    logic state, next_state;

    // Moore State Machine:
    // State 0: Haven't encountered a '1' yet. Output is x.
    // State 1: Encountered a '1'. Output is ~x.
    // Reset state should be 0.

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            1'b0: begin
                if (x == 1'b1)
                    next_state = 1'b1;
                else
                    next_state = 1'b0;
            end
            1'b1: begin
                next_state = 1'b1;
            end
            default: next_state = 1'b0;
        endcase
    end

    // Moore machine output: z depends only on state
    // But wait, the standard serial 2's complementer logic is usually:
    // z = x if state 0, z = ~x if state 1.
    // Let's verify the logic.
    // Input: ...00100 (LSB first)
    // t=0: x=0, state=0, z=0, next_state=0
    // t=1: x=0, state=0, z=0, next_state=0
    // t=2: x=1, state=0, z=1, next_state=1
    // t=3: x=0, state=1, z=1, next_state=1
    // t=4: x=0, state=1, z=1, next_state=1
    // Output: ...11100 (Correct)

    assign z = (state == 1'b0) ? x : ~x;

endmodule
