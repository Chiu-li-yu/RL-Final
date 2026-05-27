module TopModule (
    input clk,
    input d,
    output q
);
    logic q_rising;
    logic q_falling;
    logic q_out;

    // Trigger on rising edge
    always_ff @(posedge clk) begin
        q_rising <= d;
    end

    // Trigger on falling edge
    always_ff @(negedge clk) begin
        q_falling <= d;
    end

    // Select the appropriate output based on the current clock state
    always_comb begin
        q_out = clk ? q_rising : q_falling;
    end

    assign q = q_out;

endmodule
