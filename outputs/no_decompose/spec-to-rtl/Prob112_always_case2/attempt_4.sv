module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);
    // 優先權編碼器：檢查最高位元（index 3 到 0）
    // 題目要求若 bit[3] 是 1，輸出 3
    // 若 bit[2] 是 1（且 bit[3] 為 0），輸出 2
    // 若 bit[1] 是 1（且 bit[3:2] 為 0），輸出 1
    // 若 bit[0] 是 1（且 bit[3:1] 為 0），輸出 0
    // 若全是 0，輸出 0
    always @(*) begin
        if (in[3])
            pos = 2'd3;
        else if (in[2])
            pos = 2'd2;
        else if (in[1])
            pos = 2'd1;
        else
            pos = 2'd0;
    end
endmodule
