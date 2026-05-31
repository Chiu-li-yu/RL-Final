module TopModule (
    input [3:0] x,
    output f
);
    // Karnaugh Map:
    // x[2]x[3]  x[0]x[1]
    //           00  01  11  10
    //     00  | 1 | 0 | 0 | 1 |
    //     01  | 0 | 0 | 0 | 0 |
    //     11  | 1 | 1 | 1 | 0 |
    //     10  | 1 | 1 | 0 | 1 |

    // Cells (x[2]x[3], x[0]x[1]) are:
    // 0: (00, 00) -> 1
    // 3: (00, 10) -> 1
    // 12: (11, 00) -> 1
    // 13: (11, 01) -> 1
    // 14: (11, 11) -> 1
    // 8: (10, 00) -> 1
    // 9: (10, 01) -> 1
    // 11: (10, 10) -> 1

    // Mapping:
    // x[3] x[2] x[1] x[0]
    // 0    0    0    0    -> 1
    // 0    0    1    0    -> 1
    // 0    1    1    1    -> 1 (wait, map indexing)
    // The prompt says: x[2]x[3] is row, x[0]x[1] is col.
    // Indexing x as x[3:0]
    // x[2]x[3] -> row index, x[0]x[1] -> col index.

    // Let's list minterms (where f = 1):
    // Row 00 (x2=0, x3=0): Cols 00, 10 -> f=1. Indices: 0000, 0010.
    // Row 01 (x2=0, x3=1): No 1s.
    // Row 11 (x2=1, x3=1): Cols 00, 01, 11 -> f=1. Indices: 1100, 1101, 1111.
    // Row 10 (x2=1, x3=0): Cols 00, 01, 10 -> f=1. Indices: 1000, 1001, 1010.

    // Let's write the expression using logic:
    always @(*) begin
        case(x)
            4'b0000: f = 1;
            4'b0010: f = 1;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1111: f = 1;
            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1010: f = 1;
            default: f = 0;
        endcase
    end
endmodule
