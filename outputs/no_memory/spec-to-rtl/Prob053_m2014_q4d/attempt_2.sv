module TopModule(
    input clk,
    input in,
    output out
);
    logic d_ff_out;

    always_ff @(posedge clk) begin
        d_ff_out <= in ^ d_ff_out;
    end

    assign out = d_ff_out;
endmodule
