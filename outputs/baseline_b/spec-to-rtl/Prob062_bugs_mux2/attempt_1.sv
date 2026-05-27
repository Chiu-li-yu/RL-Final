module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The bug in the original code was that 'out' was defined as a 1-bit signal
    // while 'a' and 'b' were 8-bit. This caused truncation.
    // We update the output width to 8-bit and use the conditional operator for clarity.

    assign out = sel ? b : a;

endmodule
