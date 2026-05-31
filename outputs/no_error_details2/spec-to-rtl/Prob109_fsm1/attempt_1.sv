module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    // State definitions
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    logic state, next_state;

    // Asynchronous reset to State B
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: next_state = (in) ? STATE_A : STATE_B;
            STATE_B: next_state = (in) ? STATE_B : STATE_A;
            default: next_state = STATE_B;
        endcase
    end

    // Output logic (Moore machine: depends only on state)
    // A: 0, B: 1
    assign out = (state == STATE_B);

endmodule
