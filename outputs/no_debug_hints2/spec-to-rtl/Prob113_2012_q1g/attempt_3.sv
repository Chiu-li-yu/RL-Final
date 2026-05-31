module TopModule (
    input [3:0] x,
    output f
);
    // Based on K-map:
    // f = 1 at (x3, x2, x1, x0) = 0000, 0001, 1100, 1110, 1111, 0100, 0110, 0101
    // Minterms:
    // 0: ~x3 & ~x2 & ~x1 & ~x0
    // 1: ~x3 & ~x2 & ~x1 & x0
    // 4: ~x3 & x2 & ~x1 & ~x0
    // 5: ~x3 & x2 & ~x1 & x0
    // 6: ~x3 & x2 & x1 & ~x0
    // 12: x3 & x2 & ~x1 & ~x0
    // 14: x3 & x2 & x1 & ~x0
    // 15: x3 & x2 & x1 & x0

    // Simplifying:
    // f = (~x3 & ~x2 & ~x1) | (~x3 & x2 & ~x1) | (~x3 & x2 & x1 & ~x0) | (x3 & x2 & ~x1 & ~x0) | (x3 & x2 & x1)
    // f = (~x3 & ~x1) | (~x3 & x2 & ~x0) | (x3 & x2 & ~x1 & ~x0) | (x3 & x2 & x1)
    
    // Let's just use the truth table minterms to be safe given the simplicity.
    assign f = (~x[3] & ~x[2] & ~x[1] & ~x[0]) |
               (~x[3] & ~x[2] & ~x[1] &  x[0]) |
               (~x[3] &  x[2] & ~x[1] & ~x[0]) |
               (~x[3] &  x[2] & ~x[1] &  x[0]) |
               (~x[3] &  x[2] &  x[1] & ~x[0]) |
               ( x[3] &  x[2] & ~x[1] & ~x[0]) |
               ( x[3] &  x[2] &  x[1] & ~x[0]) |
               ( x[3] &  x[2] &  x[1] &  x[0]);
endmodule
