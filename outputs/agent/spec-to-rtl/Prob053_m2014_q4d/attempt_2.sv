module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic d_ff_out;

    initial begin
        d_ff_out = 1'b0;
    end

    always @(posedge clk) begin
        d_ff_out <= in ^ d_ff_out;
    end

    assign out = d_ff_out;

endmodule
