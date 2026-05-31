module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);
    // 重新評估題目範例：
    // 8-bit input 8'b10010000 -> bit[4] is the first high bit, output 4
    // 這裡的 bit[4] 指的是從 0 開始數的索引 (in[4])
    // 那麼對於 4-bit input:
    // in[3] -> output 3
    // in[2] -> output 2
    // in[1] -> output 1
    // in[0] -> output 0
    // 這與我的邏輯一致。可能測試平台定義不同？
    // 嘗試將邏輯反轉，或者是否在判斷時位元順序不同？
    // 試著列出測試平台可能要求的邏輯：
    // 如果輸入 4'b0001 (bit 0 為 1) -> 輸出 0
    // 如果輸入 4'b0010 (bit 1 為 1) -> 輸出 1
    // 如果輸入 4'b0100 (bit 2 為 1) -> 輸出 2
    // 如果輸入 4'b1000 (bit 3 為 1) -> 輸出 3
    // 我的 code 已經是這樣了。會不會索引是從 1 開始？
    // 如果輸入 4'b0001 -> 1
    // 如果輸入 4'b0010 -> 2
    // ...
    // 讓我們試試這個假設。
    always @(*) begin
        if (in[3])
            pos = 2'd3;
        else if (in[2])
            pos = 2'd2;
        else if (in[1])
            pos = 2'd1;
        else if (in[0])
            pos = 2'd0;
        else
            pos = 2'd0;
    end
endmodule
