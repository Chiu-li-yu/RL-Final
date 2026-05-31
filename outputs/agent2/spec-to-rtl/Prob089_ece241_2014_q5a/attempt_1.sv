module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    logic state, next_state;

    // Moore machine states:
    // S0: No 1 seen yet. Output = Input
    // S1: 1 seen. Output = !Input
    localparam S0 = 1'b0;
    localparam S1 = 1'b1;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Output logic
    assign z = (state == S0) ? x : ~x;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule
