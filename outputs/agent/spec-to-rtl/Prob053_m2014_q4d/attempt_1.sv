module TopModule(
    input clk,
    input in,
    output logic out
);

    logic d_ff_q;
    logic xor_out;

    assign xor_out = in ^ d_ff_q;

    always_ff @(posedge clk) begin
        d_ff_q <= xor_out;
    end

    assign out = d_ff_q;

endmodule
