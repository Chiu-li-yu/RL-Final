module TopModule (
    input [3:0] x,
    output f
);
    // Let's use the Karnaugh Map directly.
    // Row = x[2]x[3]
    // Col = x[0]x[1]
    
    // Row 00 (x2=0, x3=0): col 00, 01, 11, 10 -> f=1, 0, 0, 1
    // Row 01 (x2=0, x3=1): col 00, 01, 11, 10 -> f=0, 0, 0, 0
    // Row 11 (x2=1, x3=1): col 00, 01, 11, 10 -> f=1, 1, 1, 0
    // Row 10 (x2=1, x3=0): col 00, 01, 11, 10 -> f=1, 1, 0, 1
    
    // Input x = {x[3], x[2], x[1], x[0]}? No, the spec says "x (4 bits)".
    // Usually x[3] is MSB, x[0] is LSB.
    // Let's assume x = {x[3], x[2], x[1], x[0]}.
    // So x[2]x[3] means the bits at positions 2 and 3.
    // Let's define:
    // r = {x[2], x[3]}
    // c = {x[0], x[1]}
    
    logic f_val;
    always @(*) begin
        case ({x[2], x[3]})
            2'b00: begin
                case ({x[0], x[1]})
                    2'b00: f_val = 1'b1;
                    2'b01: f_val = 1'b0;
                    2'b11: f_val = 1'b0;
                    2'b10: f_val = 1'b1;
                endcase
            end
            2'b01: begin
                f_val = 1'b0;
            end
            2'b11: begin
                case ({x[0], x[1]})
                    2'b00: f_val = 1'b1;
                    2'b01: f_val = 1'b1;
                    2'b11: f_val = 1'b1;
                    2'b10: f_val = 1'b0;
                endcase
            end
            2'b10: begin
                case ({x[0], x[1]})
                    2'b00: f_val = 1'b1;
                    2'b01: f_val = 1'b1;
                    2'b11: f_val = 1'b0;
                    2'b10: f_val = 1'b1;
                endcase
            end
        endcase
    end
    assign f = f_val;
endmodule
