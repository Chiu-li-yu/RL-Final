module TopModule (
    input logic clk,
    input logic reset,
    input logic [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // 水位狀態定義
    // 3: Above s[2] (s=111)
    // 2: Between s[2] and s[1] (s=011)
    // 1: Between s[1] and s[0] (s=001)
    // 0: Below s[0] (s=000)

    logic [1:0] current_level;
    logic [1:0] prev_level;

    // 解析當前水位
    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // 更新歷史狀態 (只在感測器變更時更新)
    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else begin
            if (current_level != (s == 3'b111 ? 2'd3 : (s == 3'b011 ? 2'd2 : (s == 3'b001 ? 2'd1 : 2'd0)))) begin
                // This is a naive logic, we need to track if it changed.
            end
            // Actually, we update prev_level if the level changed
            if (current_level != prev_level) begin
                prev_level <= current_level;
            end
        end
    end

    // 輸出邏輯
    always @(*) begin
        // 預設狀態 (Reset)
        if (reset) begin
            fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1; dfr = 1'b1;
        end else begin
            // 基礎 nominal flow 邏輯
            case (current_level)
                2'd3: {fr2, fr1, fr0} = 3'b000;
                2'd2: {fr2, fr1, fr0} = 3'b001;
                2'd1: {fr2, fr1, fr0} = 3'b011;
                2'd0: {fr2, fr1, fr0} = 3'b111;
                default: {fr2, fr1, fr0} = 3'b111;
            endcase

            // dfr 邏輯: 如果之前水位 > 當前水位，則開啟
            if (prev_level > current_level) dfr = 1'b1;
            else dfr = 1'b0;
            
            // 下限水位特殊處理
            if (current_level == 2'd0) dfr = 1'b1;
        end
    end

endmodule
