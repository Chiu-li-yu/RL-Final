module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP logic: a'b'cd' + bcd
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // POS logic: (c+d)(b+d')(a'+d)(b'+c)
    assign out_pos = (c | d) & (b | ~d) & (~a | d) & (~b | c);

endmodule