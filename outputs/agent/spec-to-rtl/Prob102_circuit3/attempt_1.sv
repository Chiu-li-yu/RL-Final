module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic q
);
    // 根據真值表分析：
    // q = 1 當 (b=1 或 a=1) 且 (c=1 或 d=1)
    // 讓我們檢查：
    // b=1, a=1: 40ns(0101) -> q=1, 45ns(0110) -> q=1, 50ns(0111) -> q=1
    // a=1, b=0: 60ns(1001) -> q=1, 65ns(1010) -> q=1, 70ns(1011) -> q=1
    // 測試全0: 0000 -> q=0
    // 測試僅d=1: 0001 -> q=0
    // 測試僅c=1: 0010 -> q=0
    // 測試僅c&d=1: 0011 -> q=0
    // 測試僅b=1: 0100 -> q=0
    // 測試僅a=1: 1000 -> q=0
    // 測試a&b=1, c=0, d=0: 1100 -> q=0
    
    always @(*) begin
        q = (a | b) & (c | d);
    end
endmodule
