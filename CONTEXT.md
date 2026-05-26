# Verilog Coding Agent — 專題術語表

## 核心術語

**Agent**
本專題的主要系統。以 Gemini 作為核心，透過 function calling 呼叫外部工具，針對 VerilogEval 題目迭代生成並修正 Verilog 程式碼，直到通過所有 test case 或達到嘗試上限為止。

**Policy**
Agent 在每個 step 根據當前 State 決定下一步 Action 的策略。由 Gemini 擔任，透過 function calling 實現結構化的 action 選擇。不做梯度更新，屬於 In-Context RL（零樣本策略）。

**State**
Agent 在每個決策時刻的完整觀察。包含：

- `problem_description`：VerilogEval 題目敘述
- `current_code`：當前生成的 Verilog 程式碼
- `error_type`：錯誤分類代碼（見下方 Error Type）
- `error_log`：iverilog / vvp 的完整輸出 log
- `attempt_number`：目前是第幾次嘗試（1 / 2 / 3）

**Action**
Gemini 可選擇的操作。透過 function calling 結構化輸出：

- `fix_code(current_code, error_type, error_log)`：針對錯誤局部修改程式碼
- `rewrite_code(problem_description, sub_goals)`：放棄現有程式碼，根據子目標重寫
- `call_tool(tool_name, args)`：呼叫外部工具

**Reward**
每個 episode 結束後的回饋訊號：

- `+1`：所有 test case 通過（Mismatches = 0）
- `0`：達到嘗試上限仍失敗

**Episode**
一道 VerilogEval 題目從第一次嘗試到成功或放棄的完整過程（最多 3 步）。

**Attempt**
一次「生成/修改程式碼 → 編譯 → 模擬 → 觀察結果」的循環。最多 3 次。

## 工具（Tools）

**compile_tool**
呼叫 iverilog 對生成的 Verilog 程式碼進行編譯。回傳 compile log。

**simulate_tool**
呼叫 vvp 對編譯結果執行模擬，搭配 VerilogEval 的 testbench。回傳 simulation log 與 mismatch 數量。

**decompose_spec**
輸入題目敘述，回傳結構化的子目標清單（list of strings）。由 Gemini 實作（另一個 LLM call）。觸發條件：第二次嘗試仍發生 Simulation Error 時。

## Error Type

VerilogEval 的錯誤分類代碼（來自 sv-iv-analyze 腳本）：

| 代碼 | 意思                          | 類別             |
| ---- | ----------------------------- | ---------------- |
| `.`  | Pass（全部通過）              | ✅ 成功          |
| `S`  | Syntax Error                  | Compile Error    |
| `C`  | Compiler Error（通用）        | Compile Error    |
| `e`  | Explicit Cast Required        | Compile Error    |
| `0`  | Sized Numeric Constant Error  | Compile Error    |
| `n`  | No Sensitivities Warning      | Compile Error    |
| `w`  | Declared as Wire              | Compile Error    |
| `m`  | Unknown Module Type           | Compile Error    |
| `p`  | Unable to Bind Wire/Reg       | Compile Error    |
| `c`  | Unable to Bind Wire/Reg `clk` | Compile Error    |
| `R`  | Runtime Error（模擬邏輯錯誤） | Simulation Error |
| `T`  | Timeout                       | Simulation Error |
| `r`  | Async Reset（靜態分析）       | Simulation Error |

## Agent 決策流程

```
[開始]
   │
   ▼
generate_code()          ← attempt 1
   │
   ▼
compile() + simulate()
   ├─ Pass ─────────────────────────────→ [成功，輸出答案]
   │
   ├─ Compile Error
   │      ▼
   │   fix_code(error_log)               ← attempt 2
   │      ▼
   │   compile() + simulate()
   │      ├─ Pass ──────────────────────→ [成功]
   │      └─ 任何失敗 ──────────────────→ [放棄]
   │
   └─ Simulation Error (R/T)
          ▼
       fix_code(error_log)               ← attempt 2
          ▼
       compile() + simulate()
          ├─ Pass ──────────────────────→ [成功]
          └─ Simulation Error 再次
                 ▼
          decompose_spec(problem)         ← attempt 3
                 ▼
          rewrite_code(sub_goals)
                 ▼
          compile() + simulate()
                 ├─ Pass ──────────────→ [成功]
                 └─ 失敗 ──────────────→ [放棄]
```

## 評估方法

**Pass Rate**
主要指標。在 VerilogEval 156 題中，Agent 最終解出的題數比例。

**三組對比實驗：**

- **Baseline A**：Gemini 單次生成，無 error feedback（衡量「沒有 Agent」）
- **Baseline B**：Gemini 跑 3 次獨立生成，互相不共享結果（排除多次嘗試的效果，單獨衡量 feedback 的價值）
- **Agent**：完整系統（3 次嘗試 + error feedback + decompose_spec）

**各階段分析：**
追蹤每道失敗題目在第幾次嘗試解決，並按 error type 分類，說明 decompose_spec 對哪類錯誤最有效。

## 技術選型

| 項目       | 選擇                                                           | 理由                                    |
| ---------- | -------------------------------------------------------------- | --------------------------------------- |
| LLM        | Gemini（API）                                                  | 費用低、支援 native function calling    |
| Tool 介面  | Function Calling                                               | 結構化 action 輸出，符合 RL policy 框架 |
| 編譯器     | iverilog v12                                                   | VerilogEval 指定版本                    |
| 模擬器     | vvp                                                            | iverilog 配套工具                       |
| 評估資料集 | VerilogEval code-complete-iccad2023 + spec-to-rtl（各 156 題） | 現成 testbench，有基準比較數據          |
| SDK        | `google-genai`（新版）                                         | `google-generativeai` 已棄用            |

## 實作架構（2026-05-26 確定）

### Error Classification（簡化三分類）

MVP 使用三分類，夠用且不過設計：

| 類別               | 判斷條件                                            |
| ------------------ | --------------------------------------------------- |
| `pass`             | compile exit code 0 且 `Mismatches: 0 in N samples` |
| `compile_error`    | compile exit code != 0                              |
| `simulation_error` | compile 成功但 mismatch > 0，或 TIMEOUT             |

### google.genai SDK 使用注意

`GenerateContentConfig.tools` 是 pydantic 嚴格型別，**必須**使用：

```python
types.Tool(function_declarations=[types.FunctionDeclaration(...)])
```

不可用 flat dict `{"name":..., "description":..., "parameters":...}`（這是 OpenAI / 舊版格式）。

### Agent Callback 架構

`agent/agent.py::run_agent()` 提供 4 個可選 callback，讓顯示層與邏輯層分離：

```
run_agent(
    on_thinking(text)              ← Gemini 的文字思考輸出
    on_tool_call(name, args, n)    ← 工具呼叫前
    on_tool_result(name, res, n)   ← 工具呼叫後
    on_checkpoint(n, res, code)→bool ← compile_and_test 後，False 可中止
)
```

不傳任何 callback 時，`verbose=True` 仍可印出簡易進度，兩者可並用。

### 互動式 CLI（run.py）

參考 `learn-claude-code/s01_agent_loop/` 的 agent loop 模式設計。

```
run.py
├── REPL 主迴圈：while True: input(">> ")
├── run_problem(problem_id, task)
│   ├── 讀取 dataset_spec-to-rtl/{id}_prompt.txt 作為題目描述
│   ├── 呼叫 run_agent() with callbacks
│   ├── 自動儲存 outputs/{id}/attempt_N.sv
│   └── 儲存 outputs/{id}/result.json
└── Callbacks（顯示層）
    ├── _on_thinking()     → 灰色文字
    ├── _on_tool_call()    → 黃色標題 + 程式碼預覽（前 25 行）
    ├── _on_tool_result()  → decompose_spec 子目標顯示
    └── _make_checkpoint() → pass/fail + 儲存 + 人工介入
```

人工介入選項（每次 compile_and_test 失敗後）：

- `Enter` → 繼續讓 Agent 嘗試
- `a` → 中止當前題目
- `v` → 查看完整 error log，再決定
- `c` → 查看完整程式碼，再決定

### 輸出目錄結構

```
outputs/
  {problem_id}/
    attempt_1.sv     ← 每次 compile_and_test 的程式碼（不論通過與否）
    attempt_2.sv
    result.json      ← {"passed": bool, "attempts": int, "error_type": str, ...}
```
