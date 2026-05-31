module TopModule (
    input x,
    input y,
    output z
);
    logic z_val;
    assign z = z_val;

    always @(*) begin
        // 真值表分析:
        // x y | z
        // 0 0 | 1
        // 1 0 | 0
        // 0 1 | 0
        // 1 1 | 1
        // 這是一個 XNOR 邏輯: z = ~(x ^ y)
        z_val = ~(x ^ y);
    end
endmodule
