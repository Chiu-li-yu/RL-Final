module TopModule(
    input clk,
    input x,
    output z
);

    // Three D Flip-Flops
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // Logic for gates:
    // 1. XOR gate: x XOR q_xor
    // 2. AND gate: x AND (~q_and)
    // 3. OR gate:  x OR (~q_or)
    
    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & (~q_and);
        d_or  = x | (~q_or);
        
        // Final output: NOR of all three flip-flops
        z = ~(q_xor | q_and | q_or);
    end

    // Sequential logic (using synchronous reset logic implied by "initially reset to zero")
    // Standard practice for "initially reset to zero" is a reset signal,
    // but the spec only gives clk, x, z. 
    // Assuming implicit power-on reset or the flip-flops start at 0.
    
    // Actually, usually in Verilog, initializing with `initial` is for simulation.
    // If not specified, we assume standard registers.
    
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

endmodule
