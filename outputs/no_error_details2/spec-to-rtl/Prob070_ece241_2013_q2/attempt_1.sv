module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Truth table analysis (a, b, c, d)
    // 0:0000 -> 0
    // 1:0001 -> 0
    // 2:0010 -> 1
    // 3:0011 -> X
    // 4:0100 -> 0
    // 5:0101 -> 0
    // 6:0110 -> 0
    // 7:0111 -> 1
    // 8:1000 -> X
    // 9:1001 -> 0
    // 10:1010 -> 0
    // 11:1011 -> X
    // 12:1100 -> X
    // 13:1101 -> 0
    // 14:1110 -> 0
    // 15:1111 -> 1

    // SOP Simplification (Minimizing 1s):
    // K-Map for SOP:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 0  | 0  | X  | X
    //      01      | 0  | 0  | 0  | 0
    //      11      | 1  | 1  | 1  | X
    //      10      | 1  | 0  | 0  | 0
    //
    // Groups:
    // 1. (2, 3) = a'b'c
    // 2. (7, 15) = bcd
    // Simplified SOP: out_sop = a'b'c + bcd

    // POS Simplification (Minimizing 0s):
    // K-Map for 0s:
    //      cd \ ab | 00 | 01 | 11 | 10
    //      --------|----|----|----|----
    //      00      | 1  | 1  | X  | X
    //      01      | 1  | 1  | 1  | 1
    //      11      | 0  | 0  | 0  | X
    //      10      | 0  | 1  | 1  | 1
    //
    // Groups for 0s:
    // 1. (0, 1, 4, 5) = a'c'
    // 2. (6, 14) = bc d'
    // 3. (9, 13) = ac d'
    // Simplified POS: out_pos = (a + c) * (b' + c' + d) * (a' + c' + d)

    always @(*) begin
        out_sop = (~a & ~b & c) | (b & c & d);
        out_pos = (a | c) & (~b | ~c | d) & (~a | ~c | d);
    end
endmodule