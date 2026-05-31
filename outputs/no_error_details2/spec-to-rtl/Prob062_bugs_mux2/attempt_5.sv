module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The original code was:
    // module TopModule (
    //     input        sel,
    //     input  [7:0] a,
    //     input  [7:0] b,
    //     output       out
    // );
    //
    // The bug was clearly that 'out' was defined as a 1-bit wire, 
    // truncating the 8-bit input to 1-bit.

    assign out = sel ? b : a;

endmodule