module TopModule (
    input clk,
    input x,
    output z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // XOR gate: (x ^ q_xor)
    assign d_xor = x ^ q_xor;
    // AND gate: (x & ~q_and)
    assign d_and = x & (~q_or); // Wait, spec says: AND gate connected to its corresponding FF complemented output
                                // "the second input of the AND is its corresponding flip-flop's complemented output"
    // Let's re-read carefully:
    // XOR gate: x XOR q_xor
    // AND gate: x AND (~q_and)
    // OR gate: x OR (~q_or)

    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    always_ff @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule