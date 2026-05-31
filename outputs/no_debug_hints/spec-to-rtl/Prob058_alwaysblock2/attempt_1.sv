module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    assign out_assign = a ^ b;

    logic out_always_comb_q;
    always @(*) begin
        out_always_comb_q = a ^ b;
    end
    assign out_always_comb = out_always_comb_q;

    logic out_always_ff_q;
    always @(posedge clk) begin
        out_always_ff_q <= a ^ b;
    end
    assign out_always_ff = out_always_ff_q;

endmodule
