module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    logic and_val;
    logic or_val;
    logic xor_val;

    always @(*) begin
        and_val = &in;
        or_val = |in;
        xor_val = ^in;
    end

    assign out_and = and_val;
    assign out_or = or_val;
    assign out_xor = xor_val;

endmodule