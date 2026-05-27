module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    always @(*) begin
        // out_and = in[3] & in[2] & in[1] & in[0]
        // out_or  = in[3] | in[2] | in[1] | in[0]
        // out_xor = in[3] ^ in[2] ^ in[1] ^ in[0]
    end

    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule
