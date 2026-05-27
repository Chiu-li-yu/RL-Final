module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic d_ff_out;
    logic xor_out;

    assign xor_out = in ^ d_ff_out;

    always_ff @(posedge clk) begin
        d_ff_out <= xor_out;
    end

    assign out = d_ff_out;

endmodule
