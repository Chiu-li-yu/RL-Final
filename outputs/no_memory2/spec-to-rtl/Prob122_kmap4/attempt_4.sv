module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh map analysis:
    // The output is 1 when the sum of (a+b+c+d) is odd (1 or 3).
    // This is equivalent to an XOR chain: a ^ b ^ c ^ d.
    assign out = a ^ b ^ c ^ d;
endmodule
