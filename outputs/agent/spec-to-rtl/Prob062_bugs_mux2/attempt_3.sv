module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The original code was buggy because it declared 'out' as a 1-bit output,
    // which effectively performed a bitwise OR on the result of the mux operation
    // (specifically (a[7:0] & ~sel) | (b[7:0] & sel) would be truncated to 1-bit).
    // Correcting the output width to 8-bit resolves this.

    assign out = (sel) ? b : a;

endmodule
