module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table analysis:
    // When a=0, b=1: q = c | d
    // When a=1, b=0: q = c | d
    // When a=1, b=1: q = c | d
    // When a=0, b=0: q = 0
    // Simplified: q = (a | b) & (c | d)

    assign q = (a | b) & (c | d);
endmodule