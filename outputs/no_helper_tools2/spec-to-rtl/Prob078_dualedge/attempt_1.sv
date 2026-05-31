module TopModule (
    input logic clk,
    input logic d,
    output logic q
);

    logic q1, q2;

    always_ff @(posedge clk) begin
        q1 <= d ^ q2;
    end

    always_ff @(negedge clk) begin
        q2 <= d ^ q1;
    end

    assign q = q1 ^ q2;

endmodule
