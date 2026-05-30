module TopModule (
    input clk,
    input x,
    output z
);
    logic q1, q2, q3;
    logic d1, d2, d3;

    initial begin
        q1 = 1'b0;
        q2 = 1'b0;
        q3 = 1'b0;
    end

    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    always @(*) begin
        d1 = x ^ q1;
        d2 = x & (~q2);
        d3 = x | (~q3);
    end

    assign z = ~(q1 | q2 | q3);

endmodule
