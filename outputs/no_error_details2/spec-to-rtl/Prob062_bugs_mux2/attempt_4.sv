module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // According to the original snippet, the bug is likely in the output width declaration.
    // The original code had output as 1-bit, but the inputs are 8-bit.
    // The requirement is to output the chosen 8-bit value.

    assign out = sel ? b : a;

endmodule