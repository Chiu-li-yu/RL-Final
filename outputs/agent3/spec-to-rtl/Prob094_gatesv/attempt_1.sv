module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // (1) out_both: both current and left neighbour (higher index) are 1.
    // out_both[3] is don't care (spec says "we don't need to know")
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 0; // Don't care

    // (2) out_any: any of current and right neighbour (lower index) are 1.
    // out_any[0] is don't care
    assign out_any[0] = 0; // Don't care
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // (3) out_different: current is different from left neighbour.
    // Wrap around: in[3]'s left neighbour is in[0].
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule
