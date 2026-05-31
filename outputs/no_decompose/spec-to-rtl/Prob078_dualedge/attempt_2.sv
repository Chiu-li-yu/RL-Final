module TopModule (
    input logic clk,
    input logic d,
    output logic q
);
    logic q_pos, q_neg;

    // Pos-edge flip-flop
    always_ff @(posedge clk) begin
        q_pos <= d;
    end

    // Neg-edge flip-flop
    always_ff @(negedge clk) begin
        q_neg <= d;
    end

    // MUX to select based on clock level
    // q = clk ? q_pos : q_neg;
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end
endmodule
