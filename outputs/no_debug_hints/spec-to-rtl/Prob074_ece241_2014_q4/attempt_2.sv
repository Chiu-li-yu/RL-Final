module TopModule (
    input clk,
    input x,
    output z
);
    logic q1, q2, q3;
    logic d1, d2, d3;

    // XOR gate: x XOR q1
    assign d1 = x ^ q1;
    // AND gate: x AND (~q2)
    assign d2 = x & (~q2);
    // OR gate: x OR (~q3)
    assign d3 = x | (~q3);

    // D flip-flops with reset (assuming synchronous reset logic is required to initialize to 0)
    // The problem says "initially reset to zero", in Verilog we use initial or reset signal.
    // If there is no reset signal, we use initial block for simulation or assume power-up.
    // Let's add a reset mechanism if the problem implies it, or just use initial block.
    // Given the constraints, let's use an initial block for the reset.

    initial begin
        q1 = 0;
        q2 = 0;
        q3 = 0;
    end

    always_ff @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // NOR gate: !(q1 | q2 | q3)
    assign z = ~(q1 | q2 | q3);

endmodule