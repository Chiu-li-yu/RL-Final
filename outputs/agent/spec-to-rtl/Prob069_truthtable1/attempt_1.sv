module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

    logic f_logic;

    always @(*) begin
        // Truth table:
        // x3 x2 x1 | f
        // 0  0  0  | 0
        // 0  0  1  | 0
        // 0  1  0  | 1
        // 0  1  1  | 1
        // 1  0  0  | 0
        // 1  0  1  | 1
        // 1  1  0  | 0
        // 1  1  1  | 1

        // Karnaugh Map analysis:
        //      x1
        // x3x2 0 1
        // 00   0 0
        // 01   1 1
        // 11   0 1
        // 10   0 1
        
        // Groups:
        // (x2 AND NOT x3) OR (x3 AND x1)
        f_logic = (~x3 & x2) | (x3 & x1);
    end

    assign f = f_logic;

endmodule
