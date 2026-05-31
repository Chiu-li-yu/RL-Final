module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);
    logic next_state;

    // 根據觀察與真值表分析:
    // state | a | b | next_state | q
    // 0     | 0 | 0 | 0          | 0
    // 0     | 0 | 1 | 0          | 1
    // 0     | 1 | 0 | 0          | 1
    // 0     | 1 | 1 | 0          | 0
    // 1     | 0 | 0 | 1          | 1
    // 1     | 0 | 1 | 1          | 0
    // 1     | 1 | 0 | 1          | 0
    // 1     | 1 | 1 | 1          | 1

    // 觀察結果：
    // q = a ^ b ^ state
    // next_state = a & b ? ~state : state (即 next_state = (a & b) ? ~state : state)
    // 實際上觀察到：state 在 (a & b) 為真時翻轉
    // q 則簡單地為 a ^ b ^ state

    always @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = (a & b) ? ~state : state;
        q = a ^ b ^ state;
    end

endmodule
