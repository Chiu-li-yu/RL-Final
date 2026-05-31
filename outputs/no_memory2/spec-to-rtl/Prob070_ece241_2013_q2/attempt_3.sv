module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // K-Map analysis for F(a,b,c,d):
    // 0000(0):0, 0001(1):0, 0010(2):1, 0011(3):X
    // 0100(4):0, 0101(5):0, 0110(6):0, 0111(7):1
    // 1000(8):X, 1001(9):0, 1010(10):0, 1011(11):X
    // 1100(12):X, 1101(13):0, 1110(14):0, 1111(15):1

    // SOP Minimum:
    // F = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)
    //   = (~a & ~b & c & ~d) | (b & c & d)
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // POS Minimum:
    // F = (c) & (~a | b | d) & (~b | c | d) ... check K-map groups
    // Simplified POS from K-map:
    // F = (c) & (a | b | ~d) & (~a | b | d)
    assign out_pos = (c) & (a | b | ~d) & (~a | b | d);
endmodule