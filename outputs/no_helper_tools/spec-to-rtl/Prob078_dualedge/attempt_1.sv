module TopModule (
    input clk,
    input d,
    output q
);

    logic q1, q2;

    // Positive edge triggered flip-flop
    always_ff @(posedge clk) begin
        q1 <= d ^ q2;
    end

    // Negative edge triggered flip-flop
    always_ff @(negedge clk) begin
        q2 <= d ^ q1;
    end

    // Output logic
    assign q = q1 ^ q2;

endmodule
