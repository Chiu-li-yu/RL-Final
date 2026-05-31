module TopModule (
    input [3:0] x,
    output f
);
    // K-map coordinate interpretation:
    // x = {x[2], x[3], x[0], x[1]}
    // K-map table index is determined by x[2]x[3] (row) and x[0]x[1] (col)
    
    // Row 00: x[2]=0, x[3]=0 -> indices 0000, 0001, 0011, 0010
    // Row 01: x[2]=0, x[3]=1 -> indices 0100, 0101, 0111, 0110
    // Row 11: x[2]=1, x[3]=1 -> indices 1100, 1101, 1111, 1110
    // Row 10: x[2]=1, x[3]=0 -> indices 1000, 1001, 1011, 1010

    // x is {x[3], x[2], x[1], x[0]}? No, usually MSB is x[3]. 
    // Let's interpret input 'x' as 4 bits where 'x[0]' is bit 0 and 'x[3]' is bit 3.
    // The K-Map axes:
    // Row: x[2] x[3] (binary)
    // Col: x[0] x[1] (binary)

    logic f_val;
    always @(*) begin
        case ({x[2], x[3], x[0], x[1]})
            4'b0000: f_val = 1;
            4'b0001: f_val = 0;
            4'b0011: f_val = 0;
            4'b0010: f_val = 1;

            4'b0100: f_val = 0;
            4'b0101: f_val = 0;
            4'b0111: f_val = 0;
            4'b0110: f_val = 0;

            4'b1100: f_val = 1;
            4'b1101: f_val = 1;
            4'b1111: f_val = 1;
            4'b1110: f_val = 0;

            4'b1000: f_val = 1;
            4'b1001: f_val = 1;
            4'b1011: f_val = 0;
            4'b1010: f_val = 1;
            default: f_val = 0;
        endcase
    end
    assign f = f_val;
endmodule
