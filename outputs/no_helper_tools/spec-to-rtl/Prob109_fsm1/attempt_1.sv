module TopModule(
    input clk,
    input areset,
    input in,
    output out
);
    // State definition: B=0, A=1 (based on output)
    logic state, next_state;

    // Asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0; // State B
        else
            state <= next_state;
    end

    // Moore machine transitions
    // B (0) --0--> A(1)
    // B (0) --1--> B(0)
    // A (1) --0--> B(0)
    // A (1) --1--> A(1)
    always_comb begin
        case (state)
            0: next_state = (in == 1'b0) ? 1'b1 : 1'b0; // B
            1: next_state = (in == 1'b0) ? 1'b0 : 1'b1; // A
            default: next_state = 0;
        endcase
    end

    // Output is the state value
    assign out = state;

endmodule
