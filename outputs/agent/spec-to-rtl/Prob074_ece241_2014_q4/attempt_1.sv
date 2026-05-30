module TopModule (
    input clk,
    input x,
    output z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // Flip-flop updates
    always_ff @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Combinational logic for D inputs
    // XOR: x ^ q_xor
    // AND: x & ~q_and
    // OR:  x | ~q_or
    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & ~q_and;
        d_or  = x | ~q_or;
    end

    // NOR gate output
    assign z = ~(q_xor | q_and | q_or);

endmodule
