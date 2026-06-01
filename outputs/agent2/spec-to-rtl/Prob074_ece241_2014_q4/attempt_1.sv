module TopModule(
    input clk,
    input x,
    output z
);
    logic q0, q1, q2;

    initial begin
        q0 = 0;
        q1 = 0;
        q2 = 0;
    end

    always_ff @(posedge clk) begin
        q0 <= x ^ q0;
        q1 <= x & (~q1);
        q2 <= x | (~q2);
    end

    assign z = ~(q0 | q1 | q2);
endmodule