module TopModule (
    input clk,
    input d,
    output q
);
    logic q_rise, q_fall;

    always_ff @(posedge clk) begin
        q_rise <= d;
    end
    always_ff @(negedge clk) begin
        q_fall <= d;
    end

    assign q = clk ? q_rise : q_fall;
endmodule
