module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

    logic f_logic;

    always @(*) begin
        // Truth table:
        // 000 -> 0
        // 001 -> 0
        // 010 -> 1
        // 011 -> 1
        // 100 -> 0
        // 101 -> 1
        // 110 -> 0
        // 111 -> 1
        
        // Expression simplification:
        // f = (!x3 & x2) | (x3 & x1)
        f_logic = (~x3 & x2) | (x3 & x1);
    end

    assign f = f_logic;

endmodule
