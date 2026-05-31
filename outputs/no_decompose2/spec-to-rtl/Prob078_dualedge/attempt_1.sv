module TopModule (
    input clk,
    input d,
    output q
);
    logic q1, q2;
    logic clk_delayed;

    // Use two flip-flops, one for posedge, one for negedge
    // Using a delayed clock to create two distinct sampling moments
    always_ff @(posedge clk) begin
        q1 <= d;
    end

    always_ff @(negedge clk) begin
        q2 <= d;
    end

    // Use a multiplexer to choose based on the clock state
    assign q = clk ? q1 : q2;

endmodule
