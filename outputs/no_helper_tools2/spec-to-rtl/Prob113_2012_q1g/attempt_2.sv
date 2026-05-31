module TopModule (
    input [3:0] x,
    output logic f
);
    // K-map layout:
    // Rows (x2x3): 00, 01, 11, 10
    // Cols (x0x1): 00, 01, 11, 10
    //
    // Map indices (binary representation of row/col):
    // Index = {x[2], x[3], x[0], x[1]}
    //
    // Grid:
    // x2x3\x0x1 | 00 | 01 | 11 | 10
    // 00        | 1  | 0  | 0  | 1
    // 01        | 0  | 0  | 0  | 0
    // 11        | 1  | 1  | 1  | 0
    // 10        | 1  | 1  | 0  | 1
    
    always @(*) begin
        case (x)
            4'b0000: f = 1'b1; // 00 00
            4'b0010: f = 1'b1; // 00 10
            4'b1100: f = 1'b1; // 11 00
            4'b1101: f = 1'b1; // 11 01
            4'b1111: f = 1'b1; // 11 11
            4'b1000: f = 1'b1; // 10 00
            4'b1001: f = 1'b1; // 10 01
            4'b1010: f = 1'b1; // 10 10
            default: f = 1'b0;
        endcase
    end
endmodule
