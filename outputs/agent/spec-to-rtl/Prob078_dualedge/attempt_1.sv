module TopModule(
    input clk,
    input d,
    output q
);
    logic q1, q2;

    // Use two flip-flops: one for posedge, one for negedge
    always_ff @(posedge clk) begin
        q1 <= d;
    end

    always_ff @(negedge clk) begin
        q2 <= d;
    end

    // Use a mux to select between them based on clk
    assign q = clk ? q1 : q2;

endmodule
