module TopModule (
    input clk,
    input d,
    output q
);
    logic q_pos, q_neg;

    // Positive edge triggered flip-flop
    always_ff @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always_ff @(negedge clk) begin
        q_neg <= d;
    end

    // Multiplexer to select output based on clock edge
    assign q = clk ? q_pos : q_neg;

endmodule
