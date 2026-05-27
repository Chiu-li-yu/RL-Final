module TopModule (
    input clk,
    input x,
    output z
);

    logic q_xor, q_and, q_or;
    logic next_xor, next_and, next_or;

    // Gate logic:
    // XOR gate: XOR(x, q_xor)
    // AND gate: AND(x, ~q_and)
    // OR gate:  OR(x, ~q_or)
    
    always @(*) begin
        next_xor = x ^ q_xor;
        next_and = x & (~q_and);
        next_or  = x | (~q_or);
    end

    // D flip-flops
    always @(posedge clk) begin
        q_xor <= next_xor;
        q_and <= next_and;
        q_or  <= next_or;
    end

    // Three-input NOR gate
    assign z = ~(q_xor | q_and | q_or);

endmodule
