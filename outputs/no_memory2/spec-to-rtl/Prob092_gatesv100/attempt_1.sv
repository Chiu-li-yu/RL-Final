module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        // (1) out_both: in[i] and in[i+1]
        // out_both[99] = 0
        // out_both[98:0] = in[98:0] & in[99:1]
        out_both[99] = 1'b0;
        out_both[98:0] = in[98:0] & in[99:1];

        // (2) out_any: in[i] or in[i-1]
        // out_any[0] = 0
        // out_any[99:1] = in[99:1] | in[98:0]
        out_any[0] = 1'b0;
        out_any[99:1] = in[99:1] | in[98:0];

        // (3) out_different: in[i] XOR in[i+1] (with wrap around: in[99] XOR in[0])
        // out_different[99] = in[99] ^ in[0]
        // out_different[98:0] = in[98:0] ^ in[99:1]
        out_different[99] = in[99] ^ in[0];
        out_different[98:0] = in[98:0] ^ in[99:1];
    end

endmodule
