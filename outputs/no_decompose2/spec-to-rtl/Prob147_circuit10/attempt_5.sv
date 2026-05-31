module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);
    // Almost there. Mismatches at 130ns.
    // 125ns: clk=1, a=0, b=1, state=1, q=0.
    // 130ns: clk=0, a=0, b=1, state=1, q=0.
    // 135ns: clk=1, a=0, b=0, state=1, q=1.

    // Let's refine the logic.
    // Maybe next_state depends on a and b and state.
    // Or maybe q depends on a and b and state.

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = (a & b) | (state & (a | b));
        q = state ^ a ^ b;
    end

endmodule
