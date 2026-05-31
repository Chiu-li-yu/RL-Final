module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    assign out_assign = a ^ b;

    always @(*) begin
        out_always_comb = a ^ b;
    end

    logic out_always_ff_r;
    always @(posedge clk) begin
        out_always_ff_r <= a ^ b;
    end

    assign out_always_ff = out_always_ff_r;

endmodule
