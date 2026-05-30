module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // 卡諾圖邏輯分析:
    // abc | out
    // 000 | 0
    // 001 | 0 (注意：題目中bc=00, a=0對應0, 實際上根據表格bc=00,a=0是0, bc=00,a=1是1)
    // 010 | 1
    // 011 | 1
    // 100 | 1
    // 101 | 1
    // 110 | 1
    // 111 | 1
    
    // 邏輯: out = a + b + c (如果a=1, 輸出為1; 如果b=1, 輸出為1; 但c在a=0,b=0時輸出是0)
    // 檢查卡諾圖：
    // bc\a | 0 | 1
    // -----|---|---
    // 00   | 0 | 1
    // 01   | 1 | 1
    // 11   | 1 | 1
    // 10   | 1 | 1
    
    // 簡化：
    // 當 a=1 時，輸出皆為 1。
    // 當 a=0 時，輸出為 1 (當 bc != 00)
    // 即 a=0 且 (b=1 或 c=1) -> a=0 且 (b|c)
    // 合併：out = a | (b | c)
    
    logic out_temp;
    always @(*) begin
        out_temp = a | b | c;
    end
    
    assign out = out_temp;

endmodule
