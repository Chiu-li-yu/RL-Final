module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // 狀態定義: 
    // IDLE: 還沒遇到第一個 '1' (輸出為 0)
    // INVERT: 遇到第一個 '1' 之後 (輸出為 x 的反相)
    logic state, next_state;

    parameter IDLE = 1'b0;
    parameter INVERT = 1'b1;

    // 非同步重置的狀態暫存器
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // 狀態轉移邏輯
    always @(*) begin
        case (state)
            IDLE: begin
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = IDLE;
            end
            INVERT: begin
                next_state = INVERT;
            end
            default: next_state = IDLE;
        endcase
    end

    // 輸出邏輯 (Moore machine: 輸出只取決於當前狀態)
    // 當在 IDLE: 輸出 0
    // 當在 INVERT: 輸出 !x
    assign z = (state == IDLE) ? (x & 1'b0) : (!x);

endmodule
