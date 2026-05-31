module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // Moore FSM:
    // State 0: Haven't seen a '1' yet (bits are 0, complement is 0)
    // State 1: Seen a '1', bits are inverted
    logic state;
    logic next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            1'b0: next_state = x ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
        endcase
    end

    // Output logic
    // In state 0, output is the input itself (until the first 1)
    // In state 1, output is the inverse of input
    assign z = (state == 1'b0) ? x : ~x;

endmodule
