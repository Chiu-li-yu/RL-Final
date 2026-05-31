module TopModule (
    input logic [3:0] x,
    output logic f
);
    // Re-mapping input bits based on the K-map provided:
    // Row bits (high): x[3], x[2]
    // Col bits (low):  x[1], x[0]
    // The table indices are:
    // Row 00, 01, 11, 10
    // Col 00, 01, 11, 10
    
    // x input is 4 bits. Let's assume input is {x3, x2, x1, x0}
    // Mapping:
    // Table Rows (x[3]x[4] in text - but let's assume it means bits 3 and 2):
    // Table Cols (x[1]x[2] in text - but let's assume it means bits 1 and 0):
    
    // K-map Table:
    //       x1x0 00 01 11 10
    // x3x2
    // 00         d  0  d  d
    // 01         0  d  1  0
    // 11         1  1  d  d
    // 10         1  1  0  d

    always @(*) begin
        case (x)
            4'b0000: f = 1'b0; // d=0
            4'b0001: f = 1'b0;
            4'b0011: f = 1'b0; // d=0
            4'b0010: f = 1'b0; // d=0
            4'b0100: f = 1'b0;
            4'b0101: f = 1'b1; // d=1
            4'b0111: f = 1'b1;
            4'b0110: f = 1'b0;
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b0; // d=0
            4'b1110: f = 1'b0; // d=0
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1011: f = 1'b0;
            4'b1010: f = 1'b1; // d=1
            default: f = 1'b0;
        endcase
    end
endmodule
