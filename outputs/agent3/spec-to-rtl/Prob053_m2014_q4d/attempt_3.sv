module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic q;
    initial q = 0;

    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule