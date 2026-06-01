module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // 狀態定義
    // S0: 初始狀態 (尚未接收到 1)
    // S1: 收到 1
    // S2: 收到 10
    logic [1:0] state, next_state;

    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;

    // 時序邏輯
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // 組合邏輯 - 狀態轉移
    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0; // 若此時輸入為1，則組成101並跳回S1作為下一個可能的開頭
            default: next_state = S0;
        endcase
    end

    // Mealy 輸出邏輯
    // 當處於S2 (已接收 10) 且當前輸入為 1 時，輸出 z=1
    assign z = (state == S2 && x == 1'b1);

endmodule
