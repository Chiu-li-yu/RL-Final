module TopModule (
    input  clk,
    input  d,
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

    // The dual edge flip-flop logic is:
    // When clk rises, q1 updates to d, so q = q1 ^ q2 = d ^ q2 (q2 holds old value)
    // When clk falls, q2 updates to d, so q = q1 ^ q2 = q1 ^ d (q1 holds old value)
    assign q = q1 ^ q2;

endmodule
