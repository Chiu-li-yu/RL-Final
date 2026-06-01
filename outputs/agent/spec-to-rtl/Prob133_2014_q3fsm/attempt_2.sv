module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);
    // 狀態機設計:
    // A: 等待 s=1
    // B0, B1, B2: 收集 w 的狀態
    // B3: 輸出 z，同時判斷完 3 個 w 後的結果
    
    localparam STATE_A = 3'd0;
    localparam STATE_B0 = 3'd1;
    localparam STATE_B1 = 3'd2;
    localparam STATE_B2 = 3'd3;
    localparam STATE_B3 = 3'd4;
    
    logic [2:0] state, next_state;
    logic [1:0] count_w;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count_w <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            // 計數 w
            if (next_state == STATE_B1 || next_state == STATE_B2 || next_state == STATE_B3) begin
                if (state == STATE_B0) count_w <= (w ? 2'd1 : 2'd0);
                else if (state == STATE_B1) count_w <= count_w + (w ? 1'b1 : 1'b0);
                else if (state == STATE_B2) count_w <= count_w + (w ? 1'b1 : 1'b0);
            end else begin
                count_w <= 2'b0;
            end
            
            // 輸出 z: 在 State B3 輸出
            if (next_state == STATE_B3) begin
                z <= (count_w + w == 2'd2);
            end else begin
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (state)
            STATE_A: next_state = s ? STATE_B0 : STATE_A;
            STATE_B0: next_state = STATE_B1;
            STATE_B1: next_state = STATE_B2;
            STATE_B2: next_state = STATE_B3;
            STATE_B3: next_state = STATE_B0;
            default: next_state = STATE_A;
        endcase
    end
endmodule
