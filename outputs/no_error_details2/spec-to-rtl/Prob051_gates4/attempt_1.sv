module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    always @(*) begin
        // Note: Using reduction operators for multi-bit input logic
        out_and = &in;
        out_or  = |in;
        out_xor = ^in;
    end

endmodule
