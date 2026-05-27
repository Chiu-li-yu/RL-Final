module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    assign out_assign = a ^ b;

    logic out_always_comb_val;
    always @(*) begin
        out_always_comb_val = a ^ b;
    end
    assign out_always_comb = out_always_comb_val;

    logic out_always_ff_val;
    always @(posedge clk) begin
        out_always_ff_val <= a ^ b;
    end
    assign out_always_ff = out_always_ff_val;

endmodule
