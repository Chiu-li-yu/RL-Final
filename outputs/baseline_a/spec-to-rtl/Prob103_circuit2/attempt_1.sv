module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // 將真值表轉化為邏輯函數：
    // q = (a^b^c^d == 0)
    // 檢查真值表：
    // a b c d | q
    // 0 0 0 0 | 1
    // 0 0 0 1 | 0
    // 0 0 1 0 | 0
    // 0 0 1 1 | 1
    // 0 1 0 0 | 0
    // 0 1 0 1 | 1
    // 0 1 1 0 | 1
    // 0 1 1 1 | 0
    // 1 0 0 0 | 0
    // 1 0 0 1 | 1
    // 1 0 1 0 | 1
    // 1 0 1 1 | 0
    // 1 1 0 0 | 1
    // 1 1 0 1 | 0
    // 1 1 1 0 | 0
    // 1 1 1 1 | 1
    // 這是一個 XNOR 運算：~(a ^ b ^ c ^ d)

    logic q_internal;
    always @(*) begin
        q_internal = ~(a ^ b ^ c ^ d);
    end

    assign q = q_internal;
endmodule
