module TopModule(
    input clk,
    input areset,
    input in,
    output out
);
    // State B: output 1, State A: output 0
    // Diagram:
    // B (1) --0--> A
    // B (1) --1--> B
    // A (0) --0--> B
    // A (0) --1--> A
    
    logic state, next_state;

    // Asynchronous reset to B (which outputs 1)
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // State B
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            1'b1: next_state = (in == 1'b0) ? 1'b0 : 1'b1; // B -> A if 0, B if 1
            1'b0: next_state = (in == 1'b0) ? 1'b1 : 1'b0; // A -> B if 0, A if 1
            default: next_state = 1'b1;
        endcase
    end

    // Output logic (Moore: output depends only on state)
    // B outputs 1, A outputs 0
    assign out = state;

endmodule
