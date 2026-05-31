module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Using explicit bitwise selection as intended by the original logic structure,
    // but ensuring 8-bit output width matches the inputs.
    // The original code was: assign out = (~sel & a) | (sel & b);
    // Which implies 8-bit output.
    
    assign out = (sel) ? b : a;

endmodule