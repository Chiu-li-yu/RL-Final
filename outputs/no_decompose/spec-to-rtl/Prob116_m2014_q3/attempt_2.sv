module TopModule (
    input [3:0] x,
    output f
);

    // K-map based on the provided grid:
    // Rows (x[3]x[0]): 00, 01, 11, 10
    // Cols (x[1]x[2]): 00, 01, 11, 10
    //
    // The prompt says: "x (4 bits)".
    // Let's re-map the input bits to the K-map indices:
    // x = {x3, x0, x1, x2}
    // Row index = {x3, x0}, Col index = {x1, x2}
    
    // Map of f:
    // 0000 -> d, 0001 -> 0, 0011 -> d, 0010 -> d
    // 0100 -> 0, 0101 -> d, 0111 -> 1, 0110 -> 0
    // 1100 -> 1, 1101 -> 1, 1111 -> d, 1110 -> d
    // 1000 -> 1, 1001 -> 1, 1011 -> 0, 1010 -> d

    logic f_logic;

    always @(*) begin
        case (x)
            4'b0000: f_logic = 1'b0; // d
            4'b0001: f_logic = 1'b0;
            4'b0010: f_logic = 1'b0; // d
            4'b0011: f_logic = 1'b0; // d
            4'b0100: f_logic = 1'b0;
            4'b0101: f_logic = 1'b1; // d
            4'b0110: f_logic = 1'b0;
            4'b0111: f_logic = 1'b1;
            4'b1100: f_logic = 1'b1;
            4'b1101: f_logic = 1'b1;
            4'b1110: f_logic = 1'b1; // d
            4'b1111: f_logic = 1'b1; // d
            4'b1000: f_logic = 1'b1;
            4'b1001: f_logic = 1'b1;
            4'b1010: f_logic = 1'b0; // d
            4'b1011: f_logic = 1'b0;
            default: f_logic = 1'b0;
        endcase
    end

    assign f = f_logic;

endmodule
