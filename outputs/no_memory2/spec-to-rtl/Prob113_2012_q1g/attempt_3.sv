module TopModule (
    input [3:0] x,
    output f
);
    // x[3] is row index MSB (x[2]x[3] -> x[2] is row MSB, x[3] is row LSB?)
    // Wait: Let's assume standard index interpretation:
    // Row: x[2] (MSB), x[3] (LSB)
    // Col: x[0] (MSB), x[1] (LSB)
    
    // x = {x[3], x[2], x[1], x[0]}
    // Row index = {x[2], x[3]}
    // Col index = {x[0], x[1]}
    
    // Minterms:
    // Row 00, Col 00: (x2=0, x3=0, x0=0, x1=0) -> f=1
    // Row 00, Col 10: (x2=0, x3=0, x0=1, x1=0) -> f=1
    // Row 11, Col 00: (x2=1, x3=1, x0=0, x1=0) -> f=1
    // Row 11, Col 01: (x2=1, x3=1, x0=0, x1=1) -> f=1
    // Row 11, Col 11: (x2=1, x3=1, x0=1, x1=1) -> f=1
    // Row 10, Col 00: (x2=1, x3=0, x0=0, x1=0) -> f=1
    // Row 10, Col 01: (x2=1, x3=0, x0=0, x1=1) -> f=1
    // Row 10, Col 10: (x2=1, x3=0, x0=1, x1=0) -> f=1

    always @(*) begin
        case ({x[2], x[3], x[0], x[1]})
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
