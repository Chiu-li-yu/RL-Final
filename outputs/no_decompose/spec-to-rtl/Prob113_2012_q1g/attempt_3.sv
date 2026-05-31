module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-interpret the bit order.
    // Standard K-map: row index = x[3]x[2], col index = x[1]x[0]
    // The prompt says:
    // x[2]x[3]  00  01  11  10 (cols: x[0]x[1])
    // 00     | 1 | 0 | 0 | 1 |
    // 01     | 0 | 0 | 0 | 0 |
    // 11     | 1 | 1 | 1 | 0 |
    // 10     | 1 | 1 | 0 | 1 |

    // Let's assume input x is bits {x[3], x[2], x[1], x[0]}
    // Row bits = x[3], x[2]
    // Col bits = x[1], x[0]
    
    // Row 00 (x[3]=0, x[2]=0): col 00,01,11,10 -> f=1,0,0,1
    // (x3=0, x2=0, x1=0, x0=0) -> f=1
    // (x3=0, x2=0, x1=0, x0=1) -> f=0
    // (x3=0, x2=0, x1=1, x0=1) -> f=0
    // (x3=0, x2=0, x1=1, x0=0) -> f=1
    
    // Row 01 (x[3]=0, x[2]=1): col 00,01,11,10 -> f=0,0,0,0
    
    // Row 11 (x[3]=1, x[2]=1): col 00,01,11,10 -> f=1,1,1,0
    // (x3=1, x2=1, x1=0, x0=0) -> f=1
    // (x3=1, x2=1, x1=0, x0=1) -> f=1
    // (x3=1, x2=1, x1=1, x0=1) -> f=1
    // (x3=1, x2=1, x1=1, x0=0) -> f=0

    // Row 10 (x[3]=1, x[2]=0): col 00,01,11,10 -> f=1,1,0,1
    // (x3=1, x2=0, x1=0, x0=0) -> f=1
    // (x3=1, x2=0, x1=0, x0=1) -> f=1
    // (x3=1, x2=0, x1=1, x0=1) -> f=0
    // (x3=1, x2=0, x1=1, x0=0) -> f=1

    // Map:
    // f=1 for:
    // 0000, 0010, 1100, 1101, 1111, 1000, 1001, 1010
    // Binary:
    // 0000, 0010, 1100, 1101, 1111, 1000, 1001, 1010
    // (Same numbers as before, let's re-verify the input bit mapping)
    // Maybe x[0] is the MSB? Or x[3] is the LSB?
    // "x (4 bits)" usually means x[3] is MSB, x[0] is LSB.
    
    logic f_val;
    always @(*) begin
        // Try interpreting as f(x[3], x[2], x[1], x[0])
        // Row = x[3]x[2], Col = x[1]x[0]
        // This corresponds to x = {x[3], x[2], x[1], x[0]}
        // Matches the logic above. Let's try the other bit mapping just in case:
        // Row = x[2]x[3], Col = x[0]x[1]
        // This is what I tried before.
        // Let's try mapping row bits to x[0],x[1] and col to x[2],x[3]?
        
        // Let's assume f(x[0], x[1], x[2], x[3])
        // Row = x[0]x[1], Col = x[2]x[3]
        case (x)
            4'b0000: f_val = 1'b1;
            4'b0100: f_val = 1'b1; // Row 00, Col 10
            4'b0011: f_val = 1'b1; // Row 11, Col 00
            4'b0111: f_val = 1'b1; // Row 11, Col 01
            4'b1111: f_val = 1'b1; // Row 11, Col 11
            4'b0010: f_val = 1'b1; // Row 10, Col 00
            4'b0110: f_val = 1'b1; // Row 10, Col 01
            4'b1110: f_val = 1'b1; // Row 10, Col 10
            default: f_val = 1'b0;
        endcase
    end
    assign f = f_val;
endmodule
