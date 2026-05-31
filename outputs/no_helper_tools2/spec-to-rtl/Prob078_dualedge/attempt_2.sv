module TopModule (
    input logic clk,
    input logic d,
    output logic q
);

    logic q1, q2;

    // Based on the dual-edge flip-flop structure:
    // q = (clk & q1) | (~clk & q2)
    // q1 updates on posedge clk, q2 updates on negedge clk

    always_ff @(posedge clk) begin
        q1 <= d;
    end

    always_ff @(negedge clk) begin
        q2 <= d;
    end

    assign q = clk ? q1 : q2;

endmodule
