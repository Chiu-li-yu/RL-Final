module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The bug in the original code was that 'out' was defined as a 1-bit signal
    // instead of an 8-bit signal, which would truncate the result.
    assign out = sel ? b : a;

endmodule
