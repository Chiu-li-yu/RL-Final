module TopModule (
    input [3:0] x,
    output f
);
    // K-map layout:
    // x = {x[2], x[3], x[0], x[1]}
    // Rows: x[2]x[3]
    // Cols: x[0]x[1]
    
    // Map indices (binary representation of row/col):
    // Indices (row_col) = x[2]x[3]x[0]x[1]
    
    // Grid:
    //      00 01 11 10 (x0x1)
    // 00 | 1 | 0 | 0 | 1 |  (x2x3 = 00)
    // 01 | 0 | 0 | 0 | 0 |  (x2x3 = 01)
    // 11 | 1 | 1 | 1 | 0 |  (x2x3 = 11)
    // 10 | 1 | 1 | 0 | 1 |  (x2x3 = 10)
    
    // Logic extraction:
    // f = 1 when (x2,x3,x0,x1) are:
    // 0000, 0010, 1100, 1101, 1111, 1000, 1001, 1010
    
    always @(*) begin
        case (x)
            4'b0000: f = 1'b1;
            4'b0010: f = 1'b1;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b1;
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1010: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule
