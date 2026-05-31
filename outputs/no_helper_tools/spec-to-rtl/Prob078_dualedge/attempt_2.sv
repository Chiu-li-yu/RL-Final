module TopModule (
    input clk,
    input d,
    output q
);

    logic q1, q2;

    // Positive edge triggered flip-flop
    always_ff @(posedge clk) begin
        q1 <= d;
    end

    // Negative edge triggered flip-flop
    always_ff @(negedge clk) begin
        q2 <= d;
    end

    // Output logic: mux based on clk
    assign q = clk ? q1 : q2;

endmodule
