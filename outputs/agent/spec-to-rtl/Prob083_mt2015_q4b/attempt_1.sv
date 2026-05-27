module TopModule (
    input logic x,
    input logic y,
    output logic z
);
    // 分析波形:
    // (x, y) -> z
    // (0, 0) -> 1
    // (1, 0) -> 0
    // (0, 1) -> 0
    // (1, 1) -> 1
    
    // 從真值表來看:
    // 00 -> 1
    // 01 -> 0
    // 10 -> 0
    // 11 -> 1
    
    // 這其實就是 XNOR 運算：z = ~(x ^ y)
    
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule
