module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    assign out_assign = a ^ b;

    logic out_always_comb_temp;
    always @(*) begin
        out_always_comb_temp = a ^ b;
    end
    assign out_always_comb = out_always_comb_temp;

    logic out_always_ff_reg;
    always @(posedge clk) begin
        out_always_ff_reg <= a ^ b;
    end
    assign out_always_ff = out_always_ff_reg;

endmodule
