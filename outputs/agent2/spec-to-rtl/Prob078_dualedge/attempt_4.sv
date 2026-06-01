module TopModule (
    input clk,
    input d,
    output q
);
    logic q_p, q_n;

    always_ff @(posedge clk) begin
        q_p <= d;
    end

    always_ff @(negedge clk) begin
        q_n <= d;
    end

    assign q = clk ? q_p : q_n;
endmodule
