module TopModule(
    input clk,
    input areset,
    input in,
    output out
);
    // State definition
    // B: 0, A: 1
    // The problem states:
    // B (1) -> output is 1? No, diagram says B (1) means state B has output 1.
    // A (0) -> output is 0.
    
    logic state, next_state;

    // Reset logic: asynchronously reset into state B.
    // State B is associated with output 1. Let's use 1'b1 for B and 1'b0 for A.
    // Wait, let's re-read: "B (1) --0--> A", "B (1) --1--> B", "A (0) --0--> B", "A (0) --1--> A"
    // So B is state with output 1, A is state with output 0.
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // B
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            1'b1: begin // B
                if (in) next_state = 1'b1; // B
                else    next_state = 1'b0; // A
            end
            1'b0: begin // A
                if (in) next_state = 1'b0; // A
                else    next_state = 1'b1; // B
            end
            default: next_state = 1'b1;
        endcase
    end

    assign out = state;

endmodule
