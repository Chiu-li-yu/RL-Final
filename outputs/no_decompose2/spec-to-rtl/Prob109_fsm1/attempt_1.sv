module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    logic state; // B = 1, A = 0
    logic next_state;

    // Reset logic: asynchronously reset into state B (which is 1)
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;
        end else begin
            state <= next_state;
        end
    end

    // Moore machine transitions
    // B (1) --0--> A (0)
    // B (1) --1--> B (1)
    // A (0) --0--> B (1)
    // A (0) --1--> A (0)
    always @(*) begin
        case (state)
            1'b1: next_state = (in) ? 1'b1 : 1'b0; // B
            1'b0: next_state = (in) ? 1'b0 : 1'b1; // A
            default: next_state = 1'b1;
        endcase
    end

    // Output is the state itself (1 for B, 0 for A)
    assign out = state;

endmodule