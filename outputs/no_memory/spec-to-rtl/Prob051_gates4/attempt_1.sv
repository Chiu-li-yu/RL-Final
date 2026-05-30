module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    always @(*) begin
        // Use logical AND/OR/XOR reduction operators on the 4-bit input
        out_and = &in;
        out_or  = |in;
        out_xor = ^in;
    end

endmodule