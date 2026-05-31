module TopModule (
    input x,
    input y,
    output z
);
    // 觀察波形關係：
    // (x, y) | z
    // 0, 0 | 1
    // 1, 0 | 0
    // 0, 1 | 0
    // 1, 1 | 1
    // 這是一個 XNOR 閘： z = !(x ^ y)
    
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule