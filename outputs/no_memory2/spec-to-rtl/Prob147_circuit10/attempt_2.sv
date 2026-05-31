module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);
    logic state_reg;
    assign state = state_reg;

    // 分析波形:
    // q = state ^ a ^ b (猜測)
    // state 變化:
    // 狀態轉移似乎是: next_state = (a & b) | (a & state) | (b & state) (多數決?)
    // 讓我們重新檢查波形:
    // state | a | b | next_state
    // 0     | 0 | 0 | 0
    // 0     | 0 | 1 | 0
    // 0     | 1 | 0 | 0
    // 0     | 1 | 1 | 1
    // 1     | 0 | 0 | 0
    // 1     | 0 | 1 | 0
    // 1     | 1 | 0 | 0
    // 1     | 1 | 1 | 1
    //
    // 邏輯: next_state = a & b
    //
    // 檢查 q:
    // state | a | b | q
    // 0     | 0 | 0 | 0
    // 0     | 0 | 1 | 1
    // 0     | 1 | 0 | 1
    // 0     | 1 | 1 | 0
    // 1     | 0 | 0 | 1
    // 1     | 0 | 1 | 0
    // 1     | 1 | 0 | 0
    // 1     | 1 | 1 | 1
    //
    // 邏輯: q = state ^ a ^ b

    always @(posedge clk) begin
        state_reg <= (a & b);
    end

    assign q = state_reg ^ a ^ b;

endmodule