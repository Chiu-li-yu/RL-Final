module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    logic state, next_state;

    // Use 1 for B, 0 for A
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: next_state = in ? STATE_A : STATE_B;
            STATE_B: next_state = in ? STATE_B : STATE_A;
            default: next_state = STATE_B;
        endcase
    end

    // Output logic: B is 1, A is 0
    assign out = state;

endmodule