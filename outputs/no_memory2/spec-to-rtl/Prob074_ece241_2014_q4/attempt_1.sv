module TopModule (
    input logic clk,
    input logic x,
    output logic z
);
    logic q1, q2, q3;
    logic d1, d2, d3;

    // Gate logic
    always @(*) begin
        d1 = x ^ q1;
        d2 = x & (~q2);
        d3 = x | (~q3);
    end

    // Sequential logic
    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // Output logic (NOR gate)
    always @(*) begin
        z = ~(q1 | q2 | q3);
    end

    // Initialization (The problem says "initially reset to zero", 
    // usually handled by an initial block in simulation or async/sync reset)
    // Since the prompt doesn't provide a reset port, I will use initial block 
    // for simulation correctness, but ensure it's synthesized-friendly 
    // or assume the tool manages initial state.
    initial begin
        q1 = 1'b0;
        q2 = 1'b0;
        q3 = 1'b0;
    end
endmodule