module TopModule (
    input clk,
    input d,
    output q
);

    logic q1;
    logic q2;

    // Trigger on rising edge
    always_ff @(posedge clk) begin
        q1 <= d;
    end

    // Trigger on falling edge
    always_ff @(negedge clk) begin
        q2 <= d;
    end

    // Use XOR to select based on the clock state
    // When clk is high, q1 is sampled. When low, q2 is sampled.
    assign q = clk ? q1 : q2;

endmodule