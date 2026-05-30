module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-verify the K-Map:
    // x = [x3, x4, x1, x2]
    // The problem states:
    // input x (4 bits)
    // Map:
    //         x[1]x[2]
    // x[3]x[4]  00  01  11  10
    //       00 | d | 0 | d | d |
    //       01 | 0 | d | 1 | 0 |
    //       11 | 1 | 1 | d | d |
    //       10 | 1 | 1 | 0 | d |

    // Let's assume input x[3:0] maps to x[3], x[4], x[1], x[2] as x[3]=x[3], x[2]=x[2], x[1]=x[1], x[0]=x[0] 
    // Wait, the labels are x[3], x[4], x[1], x[2]. 
    // Let's assume the order is x[3], x[2], x[1], x[0] = x[3], x[4], x[1], x[2].
    // So x_row_msb = x[3], x_row_lsb = x[2]
    // x_col_msb = x[1], x_col_lsb = x[0]
    
    // Row 00: (x3=0, x2=0) -> f = d, 0, d, d
    // Row 01: (x3=0, x2=1) -> f = 0, d, 1, 0
    // Row 11: (x3=1, x2=1) -> f = 1, 1, d, d
    // Row 10: (x3=1, x2=0) -> f = 1, 1, 0, d
    
    // x3 x2 | x1 x0 | f
    // 0  0  | 0  0  | d (0)
    // 0  0  | 0  1  | 0
    // 0  0  | 1  0  | d (0)
    // 0  0  | 1  1  | d (0)
    
    // 0  1  | 0  0  | 0
    // 0  1  | 0  1  | d (0)
    // 0  1  | 1  0  | 0
    // 0  1  | 1  1  | 1
    
    // 1  1  | 0  0  | 1
    // 1  1  | 0  1  | 1
    // 1  1  | 1  0  | d (0)
    // 1  1  | 1  1  | d (0)
    
    // 1  0  | 0  0  | 1
    // 1  0  | 0  1  | 1
    // 1  0  | 1  0  | d (0)
    // 1  0  | 1  1  | 0

    // Using K-Map:
    // f = 1 when (x3, x2, x1, x0) is:
    // 0111, 1100, 1101, 1000, 1001
    
    // Let's re-verify:
    // x3 x2 x1 x0 | f
    // 0  1  1  1  | 1
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    
    // f = (~x3 & x2 & x1 & x0) | (x3 & ~x1)
    // Check:
    // 0111: (~0 & 1 & 1 & 1) | (0 & ~1) = 1 | 0 = 1 (Correct)
    // 1100: (~1 & 1 & 0 & 0) | (1 & ~0) = 0 | 1 = 1 (Correct)
    // 1101: (~1 & 1 & 0 & 1) | (1 & ~0) = 0 | 1 = 1 (Correct)
    // 1000: (~1 & 0 & 0 & 0) | (1 & ~0) = 0 | 1 = 1 (Correct)
    // 1001: (~1 & 0 & 0 & 1) | (1 & ~0) = 0 | 1 = 1 (Correct)
    // 1011: (~1 & 0 & 1 & 1) | (1 & ~1) = 0 | 0 = 0 (Correct)
    
    assign f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1]);

endmodule