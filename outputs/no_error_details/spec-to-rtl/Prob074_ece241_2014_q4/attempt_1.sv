module TopModule (
    input clk,
    input x,
    output z
);

    logic q1, q2, q3;
    logic d1, d2, d3;

    // XOR gate: (x ^ q1)
    assign d1 = x ^ q1;
    // AND gate: (x & ~q2)
    assign d2 = x & (~q2);
    // OR gate: (x | ~q3)
    assign d3 = x | (~q3);

    always_ff @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // NOR gate: !(q1 | q2 | q3)
    assign z = ~(q1 | q2 | q3);

endmodule
