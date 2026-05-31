module TopModule (
    input [3:0] x,
    output f
);
    // Karnaugh Map mapping:
    // x = {x[2], x[3], x[0], x[1]}
    // Let's map the bits based on the K-map provided:
    // Row: x[2]x[3]
    // Col: x[0]x[1]
    
    // Rows:
    // 00: 00 -> 1
    // 01: 01 -> 0
    // 11: 11 -> 1
    // 10: 10 -> 1
    
    // Columns:
    // 00: 00 -> 1
    // 01: 01 -> 0
    // 11: 11 -> 0
    // 10: 10 -> 1

    // Map the K-map to a truth table
    // Rows (x2, x3): 00, 01, 11, 10
    // Cols (x0, x1): 00, 01, 11, 10
    
    // Entries:
    // 0000: 1
    // 0001: 0
    // 0011: 0
    // 0010: 1
    
    // 0100: 0
    // 0101: 0
    // 0111: 0
    // 0110: 0
    
    // 1100: 1
    // 1101: 1
    // 1111: 1
    // 1110: 0
    
    // 1000: 1
    // 1001: 1
    // 1011: 0
    // 1010: 1

    logic f_out;

    always @(*) begin
        case (x)
            4'b0000: f_out = 1;
            4'b0001: f_out = 0;
            4'b0011: f_out = 0;
            4'b0010: f_out = 1;
            4'b0100: f_out = 0;
            4'b0101: f_out = 0;
            4'b0111: f_out = 0;
            4'b0110: f_out = 0;
            4'b1100: f_out = 1;
            4'b1101: f_out = 1;
            4'b1111: f_out = 1;
            4'b1110: f_out = 0;
            4'b1000: f_out = 1;
            4'b1001: f_out = 1;
            4'b1011: f_out = 0;
            4'b1010: f_out = 1;
            default: f_out = 0;
        endcase
    end

    assign f = f_out;

endmodule
