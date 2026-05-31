module TopModule (
    input clk,
    input in,
    output out
);

    logic q_reg;
    logic xor_out;

    assign xor_out = in ^ q_reg;

    always_ff @(posedge clk) begin
        q_reg <= xor_out;
    end

    assign out = q_reg;

endmodule
