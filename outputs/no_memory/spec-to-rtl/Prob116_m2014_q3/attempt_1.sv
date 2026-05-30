module TopModule(
    input [3:0] x,
    output f
);
    // x[3] is x3, x[2] is x4, x[1] is x1, x[0] is x2
    // Wait, the specification says:
    // x[3]x[4] for rows and x[1]x[2] for columns.
    // Usually indices are x[3], x[2], x[1], x[0]. 
    // Let's interpret:
    // row bits: x[3]x[2]
    // col bits: x[1]x[0]

    // Mapping based on input x[3]x[2]x[1]x[0]
    // Row (x[3]x[2]): 00, 01, 11, 10
    // Col (x[1]x[0]): 00, 01, 11, 10
    
    // K-map:
    //      00 01 11 10
    // 00 | d  0  d  d
    // 01 | 0  d  1  0
    // 11 | 1  1  d  d
    // 10 | 1  1  0  d

    // Let's define the function f:
    // 0000: d->0
    // 0001: 0
    // 0011: d->0
    // 0010: d->0
    // 0100: 0
    // 0101: d->0
    // 0111: 1
    // 0110: 0
    // 1100: 1
    // 1101: 1
    // 1111: d->1
    // 1110: d->1
    // 1000: 1
    // 1001: 1
    // 1011: 0
    // 1010: d->0

    // Logic:
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[2]) | (x[3] & x[2] & ~x[1])
    // Simplified logic:
    // Let's use Karnaugh map solver or brute force.
    // f = (x[3] & !x[2]) | (x[3] & !x[1]) | (!x[3] & x[2] & x[1] & x[0])
    
    assign f = (x[3] & ~x[2]) | (x[3] & ~x[1]) | (~x[3] & x[2] & x[1] & x[0]);

endmodule
