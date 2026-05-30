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
- 同步 reset 不要在 sensitivity list 裡放 posedge reset"""


# ── 除錯提示清單（按 error code 索引）────────────────────────────────────────
# 涵蓋所有 VerilogEval error code。無特定建議的 code 仍回傳說明，
# 告知 agent 直接參考 error_log 中的行號與訊息。
DEBUG_HINTS: dict[str, str] = {
    # ── Compile errors ───────────────────────────────────────────────────────
    "S": (
        "Syntax Error：iverilog 無法解析程式碼語法。\n"
        "修正方式：\n"
        "1. 查看 error_log 中的行號，確認該行附近是否有拼寫錯誤\n"
        "2. 常見原因：缺少分號、begin/end 未配對、module/endmodule 未配對\n"
        "3. 確認 port 宣告格式正確（input/output logic，不使用 wire/reg）"
    ),
    "C": (
        "Generic Compiler Error：無法歸類的 iverilog 編譯錯誤。\n"
        "修正方式：直接查看 error_log 中的行號與錯誤訊息，按提示修正。\n"
        "無特定模式可建議，請以 error_log 為準。"
    ),
    "e": (
        "Explicit cast 錯誤常見原因（iverilog 要求明確型別轉換）：\n"
        "1. 把整數常數賦值給 enum 變數（改用 enum 成員名稱，如 state <= IDLE 而非 state <= 2'd0）\n"
        "2. 三元運算符兩側混用 enum 和整數（兩側都必須是同一 enum 的成員）\n"
        "3. 對 enum 變數做算術（如 cnt <= cnt + 1）（改用 logic [N:0] 型態做計數器）\n"
        "修正方式：找到 error 行號的賦值，改用 enum 成員名稱；若需要整數轉 enum 才用 state_t'(value)。\n"
        "根本解法：改用 localparam + logic 取代 enum，可完全避免此類錯誤。\n"
        "若因題目需要使用 enum，切換狀態只能用 case 語句，禁用三元運算符，禁止對 enum 變數做算術。"
    ),
    "0": (
        "Sized numeric constant must have size > 0：使用了 0 位元寬的常數（如 0'd0）。\n"
        "修正方式：\n"
        "1. 查看 error_log 行號，找到形如 0'b0 或 0'd0 的常數\n"
        "2. 改為有意義的位元寬（如 1'b0、8'd0）\n"
        "3. 若是參數化設計，確認 parameter 值大於 0"
    ),
    "n": (
        "No sensitivities：always @(*) 區塊內沒有讀取任何訊號，導致永不觸發。\n"
        "修正方式：\n"
        "1. 確認 always @(*) 區塊內有讀取至少一個 input 訊號\n"
        "2. 若是空的 always 區塊，移除它或補上實際邏輯\n"
        "3. 純輸出賦值不需要 always，可改用 assign"
    ),
    "w": (
        "Declared as wire：對宣告為 wire 的訊號做程序性賦值（在 always 區塊內賦值）。\n"
        "修正方式：\n"
        "1. 將該訊號的宣告從 wire 改為 logic\n"
        "2. 若已使用 logic 宣告但仍報此錯，確認沒有重複宣告\n"
        "3. 建議使用 logic，不使用 wire 或 reg"
    ),
    "m": (
        "Unknown module type：引用了未定義的 module。\n"
        "修正方式：\n"
        "1. 確認沒有實例化任何 submodule（本題目通常只需實作單一 TopModule）\n"
        "2. 若有 submodule，確認名稱拼寫正確\n"
        "3. 移除不必要的 module 實例化"
    ),
    "p": (
        "Unable to bind wire/reg：port 名稱與 testbench 不符。\n"
        "修正方式：\n"
        "1. 仔細對照題目規格中的 port 名稱，確認大小寫完全一致\n"
        "2. 確認所有 port 都已宣告（沒有遺漏）\n"
        "3. 確認 port 方向（input/output）與規格一致"
    ),
    "c": (
        "Unable to bind wire/reg `clk`：時脈訊號名稱不符。\n"
        "修正方式：\n"
        "1. 將 clock port 的名稱改為 clk（testbench 固定使用此名稱）\n"
        "2. 確認 clk 宣告為 input logic 且未被重新命名"
    ),
    # ── Simulation errors ────────────────────────────────────────────────────
    "R": (
        "Runtime mismatch 常見原因（請逐項對照自己的程式碼）：\n"
        "1. Timing offset：FSM 有多餘狀態導致輸出慢一 cycle\n"
        "2. 狀態轉移條件錯誤：if (w) 應為 if (~w) 或反之\n"
        "3. 組合邏輯錯誤：output 賦值條件遺漏或邏輯反向\n"
        "4. Reset 初始值不符：state / counter 初始值與規格不符\n"
        "5. 計數器邊界：off-by-one（計數到幾才觸發）\n"
        "6. 輸出時序：z 應在哪個 state 輸出、是 Mealy 還是 Moore\n"
        "7. 若有使用 enum 完成狀態機，改用 localparam + logic 取代\n"
    ),
    "T": (
        "Timeout：模擬執行超時，通常由無窮迴圈或振盪電路造成。\n"
        "修正方式：\n"
        "1. 檢查是否有組合邏輯迴路（output 回授到自己的 always @(*) 輸入）\n"
        "2. 確認 FSM 沒有無法跳出的狀態迴圈\n"
        "3. 確認計數器有正確的終止條件\n"
        "無特定行號可參考，需從邏輯結構分析。"
    ),
    "r": (
        "Async reset detected：程式碼中偵測到非同步 reset（sensitivity list 含 posedge/negedge reset）。\n"
        "修正方式：\n"
        "1. 將 reset 改為同步處理：always @(posedge clk) 區塊內用 if (reset) 判斷\n"
        "2. 移除 sensitivity list 中的 posedge reset 或 negedge reset\n"
        "3. 同步 reset 不要在 sensitivity list 裡放 posedge reset"
    ),
    # ── Synthesis error ──────────────────────────────────────────────────────
    "Ys": (
        "yosys 合成錯誤常見原因：\n"
        "1. 不可合成語法：#delay、task/function 含不支援的語法\n"
        "2. 未定義的 module：引用了不存在的 submodule\n"
        "3. 多重驅動：同一訊號被兩個 always block 驅動\n"
        "4. 合成器無法識別的語法：部分 SystemVerilog 語法 yosys 不支援\n"
        "修正方式：查看 error_log 中的行號，移除或替換不可合成的語法。"
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
- decompose_spec：若題目複雜度高且多次修改仍無效時，可呼叫並用於分析。
- get_debug_hints：遇到出現一次以上的錯誤類型，或不確定修正方向時呼叫。傳入 error_type 取得除錯提示。
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
- decompose_spec：若題目複雜度高且多次修改仍無效時，可呼叫並用於分析。
- get_debug_hints：遇到出現一次以上的錯誤類型，或不確定修正方向時呼叫。傳入 error_type 取得除錯提示。
"""
