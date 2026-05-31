module TopModule (
    input x,
    input y,
    output z
);

    logic z_out;
    always @(*) begin
        // 真值表分析:
        // x y | z
        // 0 0 | 1
        // 1 0 | 0
        // 0 1 | 0
        // 1 1 | 1
        
        // 這是一個 XNOR 閘: ~(x ^ y)
        z_out = ~(x ^ y);
    end

    assign z = z_out;

endmodule
