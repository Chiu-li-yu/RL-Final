module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Based on the truth table:
    // q = 1 when (a^b^c^d) == 0 (Even parity)
    assign q = ~(a ^ b ^ c ^ d);
endmodule