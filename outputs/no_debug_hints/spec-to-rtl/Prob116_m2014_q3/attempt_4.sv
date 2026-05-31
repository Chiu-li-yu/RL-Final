module TopModule (
    input [3:0] x,
    output f
);
    // K-map given:
    //         x[1]x[2]
    // x[3]x[4]  00  01  11  10
    //     00 |  d | 0 | d | d |
    //     01 |  0 | d | 1 | 0 |
    //     11 |  1 | 1 | d | d |
    //     10 |  1 | 1 | 0 | d |

    // Let's assume input x[3:0] corresponds to x[3], x[4], x[1], x[2]
    // x3=x[3], x4=x[2], x1=x[1], x2=x[0]  <-- This indexing is tricky.
    // Let's try direct mapping based on the K-map visually:
    // f = 1 when (x3=1, x4=0, x1=0, x2=0) -> 1
    // f = 1 when (x3=1, x4=0, x1=0, x2=1) -> 1
    // f = 1 when (x3=1, x4=1, x1=0, x2=0) -> 1
    // f = 1 when (x3=1, x4=1, x1=0, x2=1) -> 1
    // f = 1 when (x3=0, x4=1, x1=1, x2=1) -> 1
    // This looks like f = x[3] | (x[2] & x[1] & ~x[0]) is not working.
    // Try: f = x[3] | (~x[4] & x[1]) | (~x[3] & x[4] & x[1] & x[2])
    assign f = (x[3]) | (~x[2] & x[1]) | (~x[3] & x[2] & x[1] & x[0]);
endmodule
