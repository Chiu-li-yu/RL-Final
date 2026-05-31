module TopModule (
    input logic [3:0] x,
    output logic f
);
    // Re-interpreting the K-map based on the indices:
    // Rows (x[3]x[4]): 00, 01, 11, 10
    // Cols (x[1]x[2]): 00, 01, 11, 10
    // The problem inputs are x[0], x[1], x[2], x[3] as a 4-bit vector.
    // Usually x[3] is MSB, x[0] is LSB.
    // If x = [x[3], x[2], x[1], x[0]], then the map labels x[3]x[4] and x[1]x[2] 
    // are likely a typo for the input bits order.
    
    // Let's match the indices: 
    // Row index from x[3]x[0]
    // Col index from x[2]x[1]
    
    // Row 00, 01, 11, 10 (bits x[3],x[0])
    // Col 00, 01, 11, 10 (bits x[2],x[1])
    
    always @(*) begin
        // K-Map:
        //      x[2]x[1]
        // x[3]x[0] | 00 | 01 | 11 | 10
        //      00 | d  | 0  | d  | d  
        //      01 | 0  | d  | 1  | 0  
        //      11 | 1  | 1  | d  | d  
        //      10 | 1  | 1  | 0  | d  

        // Let's set 'd' to optimize.
        // Row 00 (x3x0=00): f = 0
        // Row 01 (x3x0=01): f = (x2 & x1)
        // Row 11 (x3x0=11): f = (!x2 | !x1)
        // Row 10 (x3x0=10): f = (!x2)

        f = ((~x[3] & x[0]) & (x[2] & x[1])) | 
            ((x[3] & x[0]) & (~x[2] | ~x[1])) | 
            ((x[3] & ~x[0]) & (~x[2]));
    end
endmodule
