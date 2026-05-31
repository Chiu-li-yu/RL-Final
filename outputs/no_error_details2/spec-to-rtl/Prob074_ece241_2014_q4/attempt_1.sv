module TopModule(
    input clk,
    input x,
    output z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // XOR gate: (x XOR q_xor) -> DFF
    // AND gate: (x AND ~q_and) -> DFF
    // OR gate: (x OR ~q_or) -> DFF
    
    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & (~q_and);
        d_or = x | (~q_or);
    end

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or <= d_or;
    end

    // Three-input NOR gate: Z = ~(q_xor OR q_and OR q_or)
    assign z = ~(q_xor | q_and | q_or);
endmodule
