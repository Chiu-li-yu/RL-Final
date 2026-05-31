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

    logic ff_out;
    always @(posedge clk) begin
        ff_out <= a ^ b;
    end
    assign out_always_ff = ff_out;

endmodule