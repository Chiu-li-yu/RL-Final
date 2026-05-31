module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Truth table:
    // a b c d | Dec | Val
    // 0 0 0 0 | 0   | 0
    // 0 0 0 1 | 1   | 0
    // 0 0 1 0 | 2   | 1
    // 0 0 1 1 | 3   | X (DC)
    // 0 1 0 0 | 4   | 0
    // 0 1 0 1 | 5   | 0
    // 0 1 1 0 | 6   | 0
    // 0 1 1 1 | 7   | 1
    // 1 0 0 0 | 8   | X (DC)
    // 1 0 0 1 | 9   | 0
    // 1 0 1 0 | 10  | 0
    // 1 0 1 1 | 11  | X (DC)
    // 1 1 0 0 | 12  | X (DC)
    // 1 1 0 1 | 13  | 0
    // 1 1 1 0 | 14  | 0
    // 1 1 1 1 | 15  | 1

    // SOP logic optimization:
    // Minimized SOP: 
    // F = (!a & !b & c) | (b & c & d) | (a & c & d)
    // F = (!a & !b & c) | (c & d)
    
    // POS logic optimization:
    // Based on K-map:
    // F = (c) & (!a | d) & (!b | d)
    
    assign out_sop = (~a & ~b & c) | (c & d);
    assign out_pos = c & (~a | d) & (~b | d);

endmodule