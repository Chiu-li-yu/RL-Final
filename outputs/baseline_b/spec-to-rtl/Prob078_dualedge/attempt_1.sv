module TopModule (
    input logic clk,
    input logic d,
    output logic q
);

    logic q_pos;
    logic q_neg;

    // Triggered on rising edge
    always_ff @(posedge clk) begin
        q_pos <= d;
    end

    // Triggered on falling edge
    always_ff @(negedge clk) begin
        q_neg <= d;
    end

    // Multiplexer to select output based on clock edge
    assign q = clk ? q_pos : q_neg;

endmodule
