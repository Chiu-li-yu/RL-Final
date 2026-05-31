module TopModule (
    input logic clk,
    input logic in,
    output logic out
);
    logic d;
    logic q;

    assign d = in ^ q;
    assign out = q;

    always_ff @(posedge clk) begin
        q <= d;
    end
endmodule
