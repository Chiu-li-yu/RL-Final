module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // K-Map Analysis:
    // Inputs (a,b,c,d)
    // 0: 0000 -> 0
    // 1: 0001 -> 0
    // 2: 0010 -> 1
    // 3: 0011 -> X
    // 4: 0100 -> 0
    // 5: 0101 -> 0
    // 6: 0110 -> 0
    // 7: 0111 -> 1
    // 8: 1000 -> X
    // 9: 1001 -> 0
    // 10: 1010 -> 0
    // 11: 1011 -> X
    // 12: 1100 -> X
    // 13: 1101 -> 0
    // 14: 1110 -> 0
    // 15: 1111 -> 1

    // SOP minimization:
    // Minterms: 2 (0010), 7 (0111), 15 (1111)
    // Don't cares: 3 (0011), 8 (1000), 11 (1011), 12 (1100)
    // Groupings:
    // (0010, 0011) -> a'b'c
    // (0111, 1111) -> bc d
    // SOP = a'b'c + bcd

    // POS minimization:
    // Maxterms: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // 0: 0000, 1: 0001, 4: 0100, 5: 0101, 6: 0110, 9: 1001, 10: 1010, 13: 1101, 14: 1110
    // POS = (b+c)(a'+c)(c+d) -- Simplified expression logic:
    // out_pos is equivalent to out_sop = (b+c)(a'+c)(c+d)
    
    assign out_sop = (~a & ~b & c) | (b & c & d);
    assign out_pos = (b | c) & (~a | c) & (c | d);

endmodule