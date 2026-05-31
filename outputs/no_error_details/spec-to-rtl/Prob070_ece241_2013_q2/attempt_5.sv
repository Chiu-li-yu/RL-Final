module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth table logic
    // 0:0, 1:0, 2:1, 3:X, 4:0, 5:0, 6:0, 7:1, 8:X, 9:0, 10:0, 11:X, 12:X, 13:0, 14:0, 15:1
    
    // SOP: 
    // Minterms: 2 (0010), 7 (0111), 15 (1111)
    // Don't Cares: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    // Minimal SOP = (~a & c & ~d) | (b & c & d) | (a & b & c & d) -> (~a & ~b & c) | (b & c & d) | (a & c & d)
    // Actually, K-map shows:
    // (0010, 0011) -> ~a & ~b & c
    // (0111, 1111) -> b & c & d
    // (1011, 1111) -> a & c & d
    // SOP = (~a & ~b & c) | (b & c & d) | (a & c & d)
    assign out_sop = (~a & ~b & c) | (b & c & d) | (a & c & d);
    
    // POS:
    // Minimal POS from K-map:
    // 0s are at 0, 1, 4, 5, 6, 9, 10, 13, 14
    // POS = (c) & (a'+d) & (a+b+c')
    assign out_pos = c & (~a | d) & (a | b | ~c);

endmodule
