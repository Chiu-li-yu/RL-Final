module TopModule (
    input clk,
    input a,
    output logic q
);
    logic d1, d2;

    always @(posedge clk) begin
        d1 <= a;
        d2 <= d1;
    end

    // Based on the trace:
    // 0ns: q=x
    // 15ns (posedge): a=0, q=1
    // 25ns (posedge): a=0, q=1
    // 35ns (posedge): a=1, q=1
    // 45ns (posedge): a=1, q=0
    //
    // Let's re-analyze:
    // If d2 (delayed input) is 0, q is 1. If d2 is 1, q is 0.
    // So q = ~d2?
    // Let's re-test this logic.
    assign q = ~d2;
endmodule
