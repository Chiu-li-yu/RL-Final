module TopModule(
    input clk,
    input x,
    output z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // Based on the spec:
    // DFFs are initially reset to zero.
    // Sequential logic triggered on positive edge of the clock.
    
    always @(posedge clk) begin
        // Reset logic is implied by the specification (D flip-flops initially reset to zero).
        // Since the prompt asks for synchronous reset handling in some cases,
        // but states "initially reset to zero before the machine begins",
        // we use a non-reset block here assuming the environment handles it,
        // but Verilog logic defaults to X. To be safe, we add a reset logic?
        // Actually, the prompt says "Assume that the D flip-flops are initially reset to zero".
        // In Verilog, we can use an initial block for simulation or just rely on the testbench.
        // Let's ensure they are 0 at start.
    end

    // Using initial blocks for testbench-friendly reset
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or = 1'b0;
    end

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

    assign z = ~(q_xor | q_and | q_or);
endmodule
