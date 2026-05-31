module TopModule (
    input [3:0] x,
    output f
);
    // x[3] = row_bit1, x[2] = row_bit0
    // x[1] = col_bit0, x[0] = col_bit1
    // Wait, the specification says:
    // Row: x[2]x[3]
    // Col: x[0]x[1]
    
    // Mapping:
    // Row 00: x[2]=0, x[3]=0
    // Row 01: x[2]=0, x[3]=1
    // Row 11: x[2]=1, x[3]=1
    // Row 10: x[2]=1, x[3]=0
    
    // Col 00: x[0]=0, x[1]=0
    // Col 01: x[0]=0, x[1]=1
    // Col 11: x[0]=1, x[1]=1
    // Col 10: x[0]=1, x[1]=0
    
    // Truth table (x3 x2 x1 x0)
    // 0000 -> 1
    // 0010 -> 0
    // 0011 -> 0
    // 0001 -> 1
    // ... following the map
    
    // Map:
    // (x2,x3) (x0,x1) | f
    // 00      00      | 1
    // 00      01      | 0
    // 00      11      | 0
    // 00      10      | 1
    // 01      00      | 0
    // 01      01      | 0
    // 01      11      | 0
    // 01      10      | 0
    // 11      00      | 1
    // 11      01      | 1
    // 11      11      | 1
    // 11      10      | 0
    // 10      00      | 1
    // 10      01      | 1
    // 10      11      | 0
    // 10      10      | 1

    // Input index: x[3] x[2] x[1] x[0]
    // x2, x3, x0, x1
    
    logic val;
    always @(*) begin
        case ({x[2], x[3], x[0], x[1]})
            4'b0000: val = 1;
            4'b0001: val = 0;
            4'b0011: val = 0;
            4'b0010: val = 1;
            
            4'b0100: val = 0;
            4'b0101: val = 0;
            4'b0111: val = 0;
            4'b0110: val = 0;
            
            4'b1100: val = 1;
            4'b1101: val = 1;
            4'b1111: val = 1;
            4'b1110: val = 0;
            
            4'b1000: val = 1;
            4'b1001: val = 1;
            4'b1011: val = 0;
            4'b1010: val = 1;
            default: val = 0;
        endcase
    end
    
    assign f = val;
endmodule
