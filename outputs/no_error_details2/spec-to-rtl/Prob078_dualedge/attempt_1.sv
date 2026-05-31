module TopModule (
    input clk,
    input d,
    output q
);
    logic q_rising, q_falling;

    always_ff @(posedge clk) begin
        q_rising <= d ^ q_falling;
    end

    always_ff @(negedge clk) begin
        q_falling <= d ^ q_rising;
    end

    assign q = q_rising ^ q_falling;
endmodule
