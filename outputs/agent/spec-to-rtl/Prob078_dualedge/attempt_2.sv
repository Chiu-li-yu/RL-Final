module TopModule (
    input clk,
    input d,
    output logic q
);
    logic q_pos = 0;
    logic q_neg = 0;

    always @(posedge clk) begin
        q_pos <= d;
    end

    always @(negedge clk) begin
        q_neg <= d;
    end

    always @(*) begin
        q = clk ? q_pos : q_neg;
    end
endmodule
