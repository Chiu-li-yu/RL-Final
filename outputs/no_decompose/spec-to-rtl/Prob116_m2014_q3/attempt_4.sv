module TopModule (
    input [3:0] x,
    output f
);
    // Let's re-interpret the bit order for the K-map.
    // The columns are labeled x[1]x[2] and rows are x[3]x[4].
    // Perhaps x = {x3, x4, x1, x2} ?
    // "x[3]x[4]" -> Row indices
    // "x[1]x[2]" -> Column indices
    // And there are only 4 bits in x.
    // Let's assume x = {x[3], x[2], x[1], x[0]}
    // And the indices were just arbitrary labels in the K-map?
    // Let's look at the bits as indices: 
    // x[3], x[2], x[1], x[0]
    // The map says row is x[3]x[4] -> this is weird.
    // If x is 4 bits, maybe x[3] is the first bit, x[2] the second, x[1] third, x[0] fourth.
    // Let's try matching row/col based on the order:
    // Row = {x[3], x[0]}, Col = {x[1], x[2]}

    logic f_logic;

    always @(*) begin
        // Rows: {x[3], x[0]}, Cols: {x[1], x[2]}
        // Grid:
        //        | 00 | 01 | 11 | 10  (x[1]x[2])
        // -------------------------
        // 00 (x[3]x[0]) | d  | 0  | d  | d
        // 01 (x[3]x[0]) | 0  | d  | 1  | 0
        // 11 (x[3]x[0]) | 1  | 1  | d  | d
        // 10 (x[3]x[0]) | 1  | 1  | 0  | d

        // x = {x[3], x[2], x[1], x[0]}
        // So:
        // Row = {x[3], x[0]}
        // Col = {x[1], x[2]}
        
        case ({x[3], x[0], x[1], x[2]})
            4'b0000: f_logic = 1'b0; // d
            4'b0001: f_logic = 1'b0;
            4'b0011: f_logic = 1'b0; // d
            4'b0010: f_logic = 1'b0; // d
            
            4'b0100: f_logic = 1'b0;
            4'b0101: f_logic = 1'b1; // d
            4'b0111: f_logic = 1'b1;
            4'b0110: f_logic = 1'b0;
            
            4'b1100: f_logic = 1'b1;
            4'b1101: f_logic = 1'b1;
            4'b1111: f_logic = 1'b1; // d
            4'b1110: f_logic = 1'b1; // d
            
            4'b1000: f_logic = 1'b1;
            4'b1001: f_logic = 1'b1;
            4'b1011: f_logic = 1'b0;
            4'b1010: f_logic = 1'b1; // d
            default: f_logic = 1'b0;
        endcase
    end

    assign f = f_logic;

endmodule
