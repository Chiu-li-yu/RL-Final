module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    logic out_and_val;
    logic out_or_val;
    logic out_xor_val;

    always @(*) begin
        out_and_val = &in;
        out_or_val = |in;
        out_xor_val = ^in;
    end

    assign out_and = out_and_val;
    assign out_or = out_or_val;
    assign out_xor = out_xor_val;

endmodule
