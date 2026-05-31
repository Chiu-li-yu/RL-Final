module TopModule (
    input clk,
    input x,
    output z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // XOR gate: (x XOR q_xor)
    assign d_xor = x ^ q_xor;

    // AND gate: (x AND ~q_and)
    assign d_and = x & (~q_and);

    // OR gate: (x OR ~q_or)
    assign d_or = x | (~q_or);

    // D flip-flops with synchronous reset
    // The problem states: "initially reset to zero"
    // Usually means power-on reset or reset at t=0.
    // Assuming synchronous reset logic or a simple initialization:
    // Let's check if the simulation expects an explicit reset signal or if initialization is implicit.
    // The port list only has clk, x, z. So no reset port.
    // Use initial block for simulation reset.
    
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    always_ff @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // NOR gate output: z = ~(q_xor | q_and | q_or)
    assign z = ~(q_xor | q_and | q_or);

endmodule
