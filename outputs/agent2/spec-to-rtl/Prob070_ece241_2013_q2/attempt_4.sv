module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // SOP = a'b'c + bcd
    assign out_sop = (~a & ~b & c) | (b & c & d);
    
    // POS = (b+c)(c+d)(a'+c)
    assign out_pos = (b | c) & (c | d) & (~a | c);
endmodule
