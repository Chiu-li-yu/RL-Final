module TopModule (
    input [3:0] x,
    output f
);
    // Let's assume standard mapping x = {x3, x2, x1, x0}
    // Rows (x3 x2): 00, 01, 11, 10
    // Cols (x1 x0): 00, 01, 11, 10
    //
    // Grid:
    //      | 00 | 01 | 11 | 10
    // ---- | -- | -- | -- | --
    // 00   | d  | 0  | d  | d
    // 01   | 0  | d  | 1  | 0
    // 11   | 1  | 1  | d  | d
    // 10   | 1  | 1  | 0  | d

    logic f_logic;
    
    // Mapping inputs x[3], x[2], x[1], x[0] to the grid:
    // row = {x[3], x[2]}
    // col = {x[1], x[0]}
    
    always @(*) begin
        case (x)
            4'b0000: f_logic = 1'b0; // d=0
            4'b0001: f_logic = 1'b0;
            4'b0011: f_logic = 1'b0; // d=0
            4'b0010: f_logic = 1'b0; // d=0
            
            4'b0100: f_logic = 1'b0;
            4'b0101: f_logic = 1'b1; // d=1
            4'b0111: f_logic = 1'b1;
            4'b0110: f_logic = 1'b0;
            
            4'b1100: f_logic = 1'b1;
            4'b1101: f_logic = 1'b1;
            4'b1111: f_logic = 1'b1; // d=1
            4'b1110: f_logic = 1'b1; // d=1
            
            4'b1000: f_logic = 1'b1;
            4'b1001: f_logic = 1'b1;
            4'b1011: f_logic = 1'b0;
            4'b1010: f_logic = 1'b1; // d=1
            default: f_logic = 1'b0;
        endcase
    end

    assign f = f_logic;
endmodule
