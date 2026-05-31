module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    logic q_val;
    assign q = q_val;

    always @(*) begin
        // 分析真值表：
        // 當 b=1 或 c=1 時，輸出 q 為 1
        // 當 b=0 且 c=0 時，輸出 q 為 0 (不論 a, d 為何)
        // 簡單邏輯: q = b | c
        q_val = b | c;
    end
endmodule
