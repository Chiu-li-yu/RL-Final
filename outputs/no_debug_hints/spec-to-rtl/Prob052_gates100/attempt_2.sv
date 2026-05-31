module TopModule (
    input [99:0] in,
    output logic out_and,
    output logic out_or,
    output logic out_xor
);

    always @(*) begin
        out_and = &in;
        out_or  = |in;
        out_xor = ^in;
    end

endmodule