module TopModule (
    input clk,
    input d,
    output q
);

    logic q1, q2;
    logic clk_n;

    // Use two flip-flops: one for posedge, one for negedge
    // posedge flip-flop
    always_ff @(posedge clk) begin
        q1 <= d;
    end

    // negedge flip-flop
    always_ff @(negedge clk) begin
        q2 <= d;
    end

    // Combine the outputs using a mux controlled by the clock
    assign q = clk ? q1 : q2;

endmodule
