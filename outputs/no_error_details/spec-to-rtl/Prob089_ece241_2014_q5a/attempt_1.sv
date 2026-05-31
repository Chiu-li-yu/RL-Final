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

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            1'b0: next_state = (x == 1'b1) ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

    assign z = (state == 1'b0) ? x : ~x;

endmodule
