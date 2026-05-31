module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    logic f_logic;

    always @(*) begin
        // Truth Table:
        // x3 x2 x1 | f
        // 0  0  0  | 0
        // 0  0  1  | 0
        // 0  1  0  | 1
        // 0  1  1  | 1
        // 1  0  0  | 0
        // 1  0  1  | 1
        // 1  1  0  | 0
        // 1  1  1  | 1
        
        // Minimized Boolean expression (K-map):
        // f = (~x3 & x2) | (x3 & x1)
        f_logic = (!x3 & x2) | (x3 & x1);
    end

    assign f = f_logic;
endmodule
