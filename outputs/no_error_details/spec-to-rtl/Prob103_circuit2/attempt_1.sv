module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table analysis:
    // q = 1 when the number of 1s in inputs is even (0, 2, or 4 ones)
    // This is equivalent to XNOR operation: a ^ b ^ c ^ d == 0
    assign q = ~(a ^ b ^ c ^ d);
endmodule
