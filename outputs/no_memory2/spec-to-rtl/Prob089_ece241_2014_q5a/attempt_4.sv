module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // 狀態定義:
    // S_INIT: 初始狀態，等待第一個 1
    // S_INVERT: 遇到第一個 1 之後，反轉所有位元
    typedef enum logic {
        S_INIT = 1'b0,
        S_INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    // 狀態轉移
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S_INIT;
        else
            state <= next_state;
    end

    // 下一狀態邏輯
    always @(*) begin
        case (state)
            S_INIT: begin
                if (x)
                    next_state = S_INVERT;
                else
                    next_state = S_INIT;
            end
            S_INVERT: begin
                next_state = S_INVERT;
            end
            default: next_state = S_INIT;
        endcase
    end

    // 輸出邏輯 (Moore machine)
    always @(*) begin
        case (state)
            S_INIT: z = x; // 直到遇到第一個 1 之前，輸出不變 (x)
            S_INVERT: z = !x; // 遇到第一個 1 之後，反轉剩餘位元
            default: z = 1'b0;
        endcase
    end
endmodule
