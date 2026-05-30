module TopModule (
    input clk,
    input d,
    output q
);
    logic q1, q2;

    // Positive edge triggered FF
    always_ff @(posedge clk) begin
        q1 <= d;
    end

    // Negative edge triggered FF
    always_ff @(negedge clk) begin
        q2 <= d;
    end

    // Multiplexer based on clk edge
    assign q = clk ? q1 : q2;

endmodule
