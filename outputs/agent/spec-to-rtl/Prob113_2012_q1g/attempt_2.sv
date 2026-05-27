module TopModule (
    input logic [3:0] x,
    output logic f
);
    // K-map (x2x3 rows, x0x1 columns):
    //       x0x1
    // x2x3 00 01 11 10
    // 00   1  0  0  1
    // 01   0  0  0  0
    // 11   1  1  1  0
    // 10   1  1  0  1
    
    // Mapping inputs to binary indices:
    // x = {x[2], x[3], x[0], x[1]}? 
    // Wait, the K-map labels are x[2]x[3] and x[0]x[1].
    // Let's re-read the table carefully:
    // Rows: x[2]x[3]
    // Cols: x[0]x[1]
    // Indices:
    // row 00, col 00 -> x=0000 -> f=1
    // row 00, col 01 -> x=0001 -> f=0
    // row 00, col 11 -> x=0011 -> f=0
    // row 00, col 10 -> x=0010 -> f=1
    // row 01, col 00 -> x=0100 -> f=0
    // row 01, col 01 -> x=0101 -> f=0
    // row 01, col 11 -> x=0111 -> f=0
    // row 01, col 10 -> x=0110 -> f=0
    // row 11, col 00 -> x=1100 -> f=1
    // row 11, col 01 -> x=1101 -> f=1
    // row 11, col 11 -> x=1111 -> f=1
    // row 11, col 10 -> x=1110 -> f=0
    // row 10, col 00 -> x=1000 -> f=1
    // row 10, col 01 -> x=1001 -> f=1
    // row 10, col 11 -> x=1011 -> f=0
    // row 10, col 10 -> x=1010 -> f=1

    always @(*) begin
        f = (~x[2] & ~x[3] & ~x[0] & ~x[1]) | // 0000
            (~x[2] & ~x[3] & ~x[0] &  x[1]) | // 0010 (Wait, order is x[0]x[1]... 
                                              // Let's re-map based on the provided table order)
            (x[2] & x[3] & ~x[0] & ~x[1]) |   // 1100
            (x[2] & x[3] & ~x[0] &  x[1]) |   // 1101
            (x[2] & x[3] &  x[0] &  x[1]) |   // 1111
            (x[2] & ~x[3] & ~x[0] & ~x[1]) |  // 1000
            (x[2] & ~x[3] & ~x[0] &  x[1]) |  // 1001
            (x[2] & ~x[3] &  x[0] &  x[1]);   // 1010
    end
endmodule
