module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // SOP: (~a & ~b & c) | (b & c & d)
    // POS (Product of Sums):
    // Minimum POS form: (c) & (a | ~b | d) & (~a | b)
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = c & (a | ~b | d) & (~a | b);
endmodule