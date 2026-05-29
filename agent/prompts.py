"""
System prompts and debug hints for VerilogEval tasks.

DEBUG_HINTS: 每種 error code 對應的除錯提示清單，由 agent.py 的 compile_and_test
             dispatch handler 附加到 tool result 中，讓 LLM 在僅有 error code /
             mismatch count 的情況下能系統性診斷錯誤原因。新增 hint 只改這個檔案。

CODE_COMPLETE_PROMPT / SPEC_TO_RTL_PROMPT: 由 agent/task.py 的 Task 實例直接引用，
             不再需要 get_system_prompt()。
"""


# ── 共用規則（兩個 prompt 均適用）────────────────────────────────────────────
_RULES_COMMON = """\
- 只使用 logic 宣告，不使用 wire 或 reg, 讓程式能被合成電路
- 組合邏輯使用 always @(*)，不寫 sensitivity list
- 同步 reset 不要在 sensitivity list 裡放 posedge reset
- FSM 狀態機統一用 localparam + logic 宣告，不使用 enum（可避免型別轉換問題）：
    localparam IDLE = 2'd0, RUN = 2'd1, DONE = 2'd2;
    logic [1:0] state, next_state;
  若因題目需要使用 enum，切換狀態只能用 case 語句，禁用三元運算符，禁止對 enum 變數做算術"""


# ── 除錯提示清單（按 error code 索引）────────────────────────────────────────
DEBUG_HINTS: dict[str, str] = {
    "R": (
        "Runtime mismatch 常見原因（請逐項對照自己的程式碼）：\n"
        "1. Timing offset：FSM 有多餘狀態導致輸出慢一 cycle\n"
        "2. 狀態轉移條件錯誤：if (w) 應為 if (~w) 或反之\n"
        "3. 組合邏輯錯誤：output 賦值條件遺漏或邏輯反向\n"
        "4. Reset 初始值不符：state / counter 初始值與規格不符\n"
        "5. 計數器邊界：off-by-one（計數到幾才觸發）\n"
        "6. 輸出時序：z 應在哪個 state 輸出、是 Mealy 還是 Moore"
    ),
    "Ys": (
        "yosys 合成錯誤常見原因：\n"
        "1. 不可合成語法：initial block、#delay、task/function 含不支援的語法\n"
        "2. 未定義的 module：引用了不存在的 submodule\n"
        "3. 多重驅動：同一訊號被兩個 always block 驅動\n"
        "4. 合成器無法識別的語法：部分 SystemVerilog 語法 yosys 不支援\n"
        "修正方式：查看 error_log 中的行號，移除或替換不可合成的語法。"
    ),
    "e": (
        "Explicit cast 錯誤常見原因（iverilog 要求明確型別轉換）：\n"
        "1. 把整數常數賦值給 enum 變數（改用 enum 成員名稱，如 state <= IDLE 而非 state <= 2'd0）\n"
        "2. 三元運算符兩側混用 enum 和整數（兩側都必須是同一 enum 的成員）\n"
        "3. 對 enum 變數做算術（如 cnt <= cnt + 1）（改用 logic [N:0] 型態做計數器）\n"
        "修正方式：找到 error 行號的賦值，改用 enum 成員名稱；若需要整數轉 enum 才用 state_t'(value)。\n"
        "根本解法：考慮改用 localparam + logic 取代 enum，可完全避免此類錯誤。"
    ),
}


# ── System prompts ────────────────────────────────────────────────────────────

CODE_COMPLETE_PROMPT = f"""你是一個 Verilog RTL 設計師。
你的任務是根據題目描述，補全給定的 Verilog module 內部邏輯。

規則：
- 輸出必須是完整的 module，包含 module TopModule (...) 到 endmodule
- module 的 port 介面已在題目中給定，不需修改
{_RULES_COMMON}

驗證流程（必須依序完成）：
1. 呼叫 compile_and_test 驗證模擬正確性
2. 模擬通過後，呼叫 synthesize 驗證可合成性
3. 兩者皆通過才算完成

其他可用工具：
- decompose_spec, 若因邏輯錯誤失敗超過一次，可呼叫並用於分析。
"""

SPEC_TO_RTL_PROMPT = f"""你是一個 Verilog RTL 設計師。
你的任務是根據自然語言規格，從零設計並實作完整的 Verilog module。

規則：
- 輸出必須是完整的 module, 包含 port 宣告到 endmodule, module 名稱必須是 TopModule
- port 名稱與方向必須與題目規格完全一致
{_RULES_COMMON}

驗證流程（必須依序完成）：
1. 呼叫 compile_and_test 驗證模擬正確性
2. 模擬通過後，呼叫 synthesize 驗證可合成性
3. 兩者皆通過才算完成

其他可用工具：
- decompose_spec, 若因邏輯錯誤失敗超過一次，可呼叫並用於分析。
"""
