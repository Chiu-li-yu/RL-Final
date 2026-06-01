module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);
    // 簡單的狀態機：
    // A: 等待 s
    // B: 已經進入監測週期
    // 當在 B 時，監測 3 個 clock 的 w，計數 w=1 的次數
    // 在第 4 個 clock 輸出 z
    
    logic [1:0] state; // 0: A, 1: B, 2: C
    logic [1:0] count_w;
    logic [1:0] clk_cnt;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 0;
            count_w <= 0;
            clk_cnt <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin // A
                    if (s) state <= 1;
                    count_w <= 0;
                    clk_cnt <= 0;
                    z <= 0;
                end
                1: begin // B
                    clk_cnt <= clk_cnt + 1;
                    count_w <= count_w + w;
                    if (clk_cnt == 2) begin
                        state <= 2;
                        z <= (count_w + w == 2);
                    end
                end
                2: begin // C (output z phase)
                    state <= 1;
                    count_w <= 0;
                    clk_cnt <= 0;
                    z <= 0;
                end
            endcase
        end
    end
endmodule
