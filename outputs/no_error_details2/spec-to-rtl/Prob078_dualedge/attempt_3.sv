module TopModule (
    input clk,
    input d,
    output q
);
    logic q_rise, q_fall;

    always_ff @(posedge clk) q_rise <= d ^ q_fall;
    always_ff @(negedge clk) q_fall <= d ^ q_rise;

    assign q = q_rise ^ q_fall;
endmodule
