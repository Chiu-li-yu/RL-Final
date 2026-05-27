module TopModule (
    input [3:0] x,
    output f
);
    // x[3] is the most significant bit (row), x[4] is the next (row), 
    // x[1] is the next (col), x[2] is the least significant (col).
    // The Karnaugh Map:
    // x[3]x[4] \ x[1]x[2] | 00 | 01 | 11 | 10
    // ----------------------------------------
    // 00                  | d  | 0  | d  | d
    // 01                  | 0  | d  | 1  | 0
    // 11                  | 1  | 1  | d  | d
    // 10                  | 1  | 1  | 0  | d

    // Assigning don't cares (d) to make the function simpler:
    // Minterms (ones):
    // (01, 11) -> 0111 (7)
    // (11, 00) -> 1100 (12)
    // (11, 01) -> 1101 (13)
    // (10, 00) -> 1000 (8)
    // (10, 01) -> 1001 (9)

    // Let's set 'd's to simplify the logic:
    // Map:
    // 00: d, 0, d, d -> set all to 0
    // 01: 0, d, 1, 0 -> set d to 0 -> 0,0,1,0
    // 11: 1, 1, d, d -> set d to 0 -> 1,1,0,0
    // 10: 1, 1, 0, d -> set d to 0 -> 1,1,0,0

    logic f_out;
    always @(*) begin
        case (x)
            4'b0111: f_out = 1'b1;
            4'b1100: f_out = 1'b1;
            4'b1101: f_out = 1'b1;
            4'b1000: f_out = 1'b1;
            4'b1001: f_out = 1'b1;
            default: f_out = 1'b0;
        endcase
    end
    assign f = f_out;
endmodule
