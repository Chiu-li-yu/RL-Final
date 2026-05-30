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

**get_debug_hints**
輸入 error_type 代碼（例如 `R`、`e`、`Ys`），回傳對應的除錯提示文字（來自 `agent/prompts.py` 的 `DEBUG_HINTS`）。`error_type` 參數**由 LLM 自行填入**（非程式自動偵測），測試 LLM 是否能正確識別錯誤類型並主動尋求幫助。呼叫行為本身即為一種可追蹤的決策動作，記錄於 result.json 的工具序列中。無對應提示時回傳空字串（行為安全）。

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

## 實作架構（2026-05-26 確定，2026-05-30 更新）

### Error Classification（15-code 細粒度分類）

直接移植 VerilogEval `sv-iv-analyze` 腳本的 `analyze_result()` 邏輯，
讓我們的結果可以直接與 VerilogEval 公開基準比較。

| 代碼 | 意思                         | 類別             | 判斷方式                                         |
| ---- | ---------------------------- | ---------------- | ------------------------------------------------ |
| `.`  | Pass                         | ✅ 成功          | `Mismatches: 0 in N samples`                     |
| `S`  | Syntax Error                 | Compile Error    | log 含 `"syntax error"`                          |
| `e`  | Explicit Cast Required       | Compile Error    | log 含 `"explicit cast"`                         |
| `0`  | Sized Numeric Constant Error | Compile Error    | log 含 `"size greater than zero"`                |
| `n`  | No Sensitivities             | Compile Error    | log 含 `"no sensitivities"`                      |
| `w`  | Declared as Wire             | Compile Error    | log 含 `"declared here as wire"`                 |
| `m`  | Unknown Module Type          | Compile Error    | log 含 `"Unknown module type"`                   |
| `c`  | Unable to Bind `clk`         | Compile Error    | log 含 `"Unable to bind wire/reg/memory \`clk'"` |
| `p`  | Unable to Bind Wire/Reg      | Compile Error    | log 含 `"Unable to bind wire/reg"`（非 clk）     |
| `C`  | Generic Compiler Error       | Compile Error    | 兜底：其他含 `"error"` 的情況                    |
| `T`  | Timeout                      | Simulation Error | log 含 `"TIMEOUT"` 或 Python `TimeoutExpired`    |
| `r`  | Async Reset（靜態分析）      | Simulation Error | verilog source 含 `posedge/negedge reset`        |
| `R`  | Runtime Error / Mismatch     | Simulation Error | `Mismatches: N > 0`，或無法識別輸出              |
| `Y`  | Synthesis Pass               | ✅ 合成成功      | yosys returncode == 0                            |
| `Ys` | Synthesis Error              | Synthesis Error  | yosys returncode != 0                            |

實作在 `agent/tools.py`：模擬分類由 `_classify_compile()` 和 `_classify_sim()` 負責；合成分類內嵌於 `synthesize()` 函式。

公開常數供 evaluate.py 使用：

```python
from agent.tools import (
    COMPILE_ERROR_CODES, SIM_ERROR_CODES, SYNTH_ERROR_CODES,
    PASS_CODE, SYNTH_PASS_CODE,
)
COMPILE_ERROR_CODES = frozenset({"S", "C", "e", "0", "n", "w", "m", "p", "c"})
SIM_ERROR_CODES     = frozenset({"R", "T", "r"})
SYNTH_ERROR_CODES   = frozenset({"Ys"})
PASS_CODE           = "."
SYNTH_PASS_CODE     = "Y"
```

#### DEBUG_HINTS — 按 error code 索引的除錯提示清單

集中管理在 `agent/prompts.py` 的 `DEBUG_HINTS` dict。LLM 透過 `get_debug_hints(error_type)` 工具主動查詢，**不再自動附加**。

涵蓋所有合法 error code（`.` 和 `Y` 為通過狀態，不需要提示）：

| Code | 提示類型 |
|------|---------|
| `S` | 語法錯誤常見原因（缺分號、begin/end 未配對等） |
| `C` | 告知直接參考 error_log 行號（無固定模式） |
| `e` | 3 項觸發原因 + 根本解法（改用 localparam + logic） |
| `0` | 0 位元寬常數的修正方式 |
| `n` | always @(*) 無敏感訊號的原因與修正 |
| `w` | wire 被程序性賦值，改用 logic |
| `m` | 未定義 module，移除不必要的實例化 |
| `p` | port 名稱不符，對照題目規格 |
| `c` | clk 名稱不符，固定用 `clk` |
| `R` | 6 項 runtime mismatch 子類型假設清單 |
| `T` | Timeout 常見原因（告知無固定行號可參考） |
| `r` | 非同步 reset，改為同步處理 |
| `Ys` | 4 項 yosys 合成錯誤：initial/delay、未定義 module、多重驅動、不支援語法 |

設計原則：所有合法 error code 均有回應。LLM 填入不存在的 code 時回傳空字串（「無對應提示」），行為安全不報錯。新增 hint 只改 `prompts.py` 的 `DEBUG_HINTS`，其他模組不需動。

#### System Prompt FSM 規範

兩個 prompt 的 enum 規則改為正向模板，直接給出推薦寫法：

```
- FSM 狀態機統一用 localparam + logic 宣告，不使用 enum（可避免型別轉換問題）：
    localparam IDLE = 2'd0, RUN = 2'd1, DONE = 2'd2;
    logic [1:0] state, next_state;
  若因題目需要使用 enum，切換狀態只能用 case 語句，禁用三元運算符，禁止對 enum 變數做算術
```

動機：LLM 在 FSM 題目中傾向使用 `enum + 三元運算符`，但 iverilog 的嚴格型別檢查會觸發 `e` 錯誤。提供正向模板比純禁止清單更有效，讓模型直接走 localparam 路徑。

### 合成工具（synthesize）

`agent/tools.py::synthesize(verilog_code)` 使用 yosys 對程式碼進行合成性檢查：

```bash
yosys -q -p "read_verilog -sv {file}; synth -top TopModule -flatten"
```

- 只做合成性驗證，不產生 netlist
- **不**將 latch 警告視為失敗（無法保證題目設計不需要 latch）
- yosys 未安裝時回傳友好錯誤訊息（`error_type: "Ys"`, `error_log: "yosys not found"`）
- 安裝：`sudo apt install yosys`

### Two-Phase Pass System（兩階段通過）

Pass 的定義從「模擬 Mismatches=0」改為「模擬通過 **AND** 合成通過」。

```
result["passed"] = result["sim_passed"] AND result["synth_passed"]
```

**Episode 最佳結果追蹤：**

```python
# 分數：sim+synth=2 > sim-only=1 > 未通過=0
# 每次 compile_and_test 或 synthesize 後更新 _best
ep.record_sim(sim_result, code)    # 重置 synth 狀態
ep.record_synth(synth_result)      # 更新 best
ep.to_result()                     # 回傳歷史最佳
```

**更新後的 `result.json` 格式：**

```json
{
  "problem_id": "Prob001_zero",
  "passed": true,
  "sim_passed": true,
  "synth_passed": true,
  "attempts": 2,
  "sim_error_type": ".",
  "sim_error_log": "",
  "synth_error_type": "Y",
  "synth_error_log": "",
  "task": "spec-to-rtl",
  "experiment": "agent"
}
```

`max_attempts` 從 3 改為 **5**（合成驗證可能需要更多 attempt 修復）。

### 合成排除清單（agent/dataset.py）

部分 VerilogEval 題目的 ref.sv 使用 `initial` 設定上電初始值，這在 FPGA 合成中合法，但 yosys generic `synth` 不支援，會對正確答案誤判為合成失敗。

掃描全部 156 題 ref.sv 的結果：

- `initial` 出現：Prob031、034、053、104
- tri-state / `inout` / `readmemh` / `real` / `time`：無

Prob031 的正解不需要 `initial` 也能通過，故保留。其餘三題從實驗資料集排除，實際跑 **153 題**。

```python
# agent/dataset.py
_SYNTH_EXCLUDED: frozenset[str] = frozenset({
    "Prob034_dff8",
    "Prob053_m2014_q4d",
    "Prob104_mt2015_muxdff",
})

def list_problems(task: Task) -> list[str]:
    # 過濾排除清單，回傳 153 題
```

### Task 配置模組（agent/task.py）

所有 task-specific 知識（dataset 路徑、system prompt、名稱字串）集中在 `agent/task.py`，其餘模組不再各自定義 `_DATASET_DIRS`：

```python
@dataclass(frozen=True)
class Task:
    name:          str    # "spec-to-rtl" 或 "code-complete-iccad2023"
    dataset_dir:   Path   # ref.sv / test.sv / ifc.txt
    prompt_dir:    Path   # _prompt.txt（自然語言描述）
    system_prompt: str    # 直接傳給 Gemini

SPEC_TO_RTL           = Task(name="spec-to-rtl",           ...)
CODE_COMPLETE_ICCAD2023 = Task(name="code-complete-iccad2023", ...)

def get_task(name: str) -> Task: ...   # CLI --task 解析用
```

`tools.py` 改接 `dataset_dir: Path`（不再知道 task 名稱），`dataset.py` / `agent.py` 改接 `task: Task`。

### API Retry 機制

`agent/agent.py` 的 `_with_retry()` 以指數退避重試所有 Gemini API 呼叫：

```
處理例外：ResourceExhausted (429)、ServiceUnavailable (503)、DeadlineExceeded (504)
退避策略：首次等待 ~4s，每次翻倍，最長 60s，最多 5 次重試
Jitter：加入 0–2s 隨機抖動，避免多個 worker 同時重試的驚群效應
```

所有 `chat.send_message()` 和 `client.models.generate_content()` 呼叫都已包在 `_with_retry()` 內。

### google.genai SDK 使用注意

`GenerateContentConfig.tools` 是 pydantic 嚴格型別，**必須**使用：

```python
types.Tool(function_declarations=[types.FunctionDeclaration(...)])
```

不可用 flat dict `{"name":..., "description":..., "parameters":...}`（這是 OpenAI / 舊版格式）。

### Experiment 登錄表（agent/experiments.py）

實驗配置的單一來源，`evaluate.py` 與 `run.py` 從此 import，不再各自維護：

```python
@dataclass(frozen=True)
class Experiment:
    id:               str
    enabled_tools:    frozenset[str] | None  # None = 全部工具
    max_attempts:     int                    # 每次 run_agent() 的上限
    independent_runs: int                    # 1 = 有記憶；>1 = no_memory 模式
    description:      str
```

| id | enabled_tools | independent_runs |
|----|--------------|-----------------|
| `agent` | 全部 | 1 |
| `no_debug_hints` | compile + synthesize + decompose_spec | 1 |
| `no_decompose` | compile + synthesize + get_debug_hints | 1 |
| `no_helper_tools` | compile + synthesize | 1 |
| `no_memory` | 全部 | 5（每次 max_attempts=1）|

### Agent Callback 架構

`agent/agent.py::run_agent()` 提供 5 個可選 callback，讓顯示層與邏輯層分離：

```
run_agent(
    on_thinking(text)                    ← Gemini 的文字思考輸出
    on_tool_call(name, args, n)          ← 工具呼叫前
    on_tool_result(name, res, n)         ← 工具呼叫後
    on_save(n, code)                     ← compile_and_test 後，純 I/O，儲存程式碼
    on_checkpoint(n, res, code) → bool | str
                                         ← compile_and_test 後，控制流 + 可選注入
)
```

`on_checkpoint` 回傳值語意：
- `False`：中止 agent
- `True`：繼續
- `str`（非空）：繼續，**並將此字串嵌入 compile_and_test 的 function response 的 `user_direction` 欄位**——確保 agent 在同一輪 API call 中同時看到 compile 結果與使用者修改方向，避免 chat history 不一致

**Callback Adapter 設計：**
- `run.py` 互動模式使用 `RunObserver(problem_id, task, experiment)` class，持有 per-problem 上下文，取代 5 個分散的 closure 函式
- `evaluate.py` 批次模式使用 `BatchObserver(problem_id, task, experiment, attempt_offset)` class，只實作 `on_save`

### Tool Dispatch 架構（agent/agent.py）

工具呼叫透過 `_DISPATCH_TABLE` 路由，每個工具有獨立 handler 函式：

```
_DISPATCH_TABLE = {
    "compile_and_test": _handle_compile_and_test,
    "synthesize":       _handle_synthesize,
    "decompose_spec":   _handle_decompose_spec,
    "get_debug_hints":  _handle_get_debug_hints,
}
```

每個 handler 接收 `(fc, _DispatchCtx)` → 回傳 `_DispatchOut(part, should_stop, user_hint)`。
新增工具只需加一個 handler 函式 + 一個 dict entry。

### 互動式 CLI（run.py）

```
run.py
├── REPL 主迴圈：while True: input(">> ")
├── run_problem(problem_id, task, experiment)
│   ├── get_experiment(experiment) → Experiment config
│   ├── obs = RunObserver(problem_id, task, experiment)
│   ├── run_agent(..., enabled_tools=exp.enabled_tools, on_*=obs.*)
│   └── save_result(...)
└── RunObserver（顯示層 + I/O + 控制流，集中於一個 class）
    ├── on_thinking()      → 灰色文字
    ├── on_tool_call()     → 黃色標題 + 程式碼預覽
    ├── on_tool_result()   → 工具結果顯示
    ├── on_save()          → 儲存 attempt_N.sv
    └── on_checkpoint()    → pass/fail + 人工介入（Enter/a/v/c/h）
```

人工介入選項（每次 compile_and_test 失敗後）：
- `Enter` → 繼續讓 Agent 嘗試
- `a` → 中止當前題目
- `v` → 查看完整 error log
- `c` → 查看完整程式碼
- `h` → 補充修改方向（嵌入 function response）

### 輸出目錄結構

五組實驗分層存放：

```
outputs/
  {experiment}/              ← "agent" | "no_debug_hints" | "no_decompose" | ...
    {task}/                  ← "spec-to-rtl" | "code-complete-iccad2023"
      {problem_id}/
        attempt_1.sv         ← 每次 compile_and_test 的程式碼（不論通過與否）
        attempt_2.sv
        result.json          ← 統計數據
        run.log              ← 完整執行紀錄（think + 工具呼叫序列 + error log）
```

`result.json` 格式（`task` 與 `experiment` 自動注入，方便跨組分析）：

```json
{
  "problem_id": "Prob001_zero",
  "passed": true,
  "attempts": 2,
  "error_type": ".",
  "error_log": "",
  "task": "spec-to-rtl",
  "experiment": "agent"
}
```

### 批次評估（evaluate.py）

`evaluate.py` 是三組實驗的批次執行器，對 `agent.agent.run_agent()` 進行薄層包裝。

#### 三組執行器的對映關係

| 實驗         | 執行方式                                 | 目的                                        |
| ------------ | ---------------------------------------- | ------------------------------------------- |
| `agent`      | `run_agent(max_attempts=3)`              | 完整系統（feedback + decompose_spec）       |
| `baseline_a` | `run_agent(max_attempts=1)`              | 無 feedback 基準                            |
| `baseline_b` | 3 × `run_agent(max_attempts=1)` 獨立呼叫 | 3 次機會但無 feedback，隔離 feedback 的價值 |

**Baseline B 的 attempt 對映**：每次獨立呼叫帶入 `attempt_offset=0/1/2`，程式碼依序存為 `attempt_1.sv`、`attempt_2.sv`、`attempt_3.sv`。`result.json` 的 `attempts` 欄位記錄「第幾次才成功」（1/2/3），全部失敗則為 3。

#### \_save_cb（batch 模式 checkpoint）

```python
def _save_cb(problem_id, task, experiment, attempt_offset=0):
    def on_checkpoint(attempt, result, code) -> bool:
        save_code(problem_id, attempt + attempt_offset, code, ...)
        return True   # 永不中斷 agent
    return on_checkpoint
```

與 `run.py` 的 `_make_checkpoint` 相同介面，但移除人工介入邏輯，批次執行時永遠回傳 `True`。

#### 進度追蹤（\_Progress）

執行緒安全的計數器，由 `threading.Lock` 保護。每次 `update()` 在鎖內列印一行，因此多個 worker 的輸出行不會交錯。最終 `finish()` 列印 pass rate 與 pass-by-attempt 長條圖。

#### CLI 用法

```bash
python evaluate.py --exp agent      --task spec-to-rtl            # 跑全部 156 題
python evaluate.py --exp baseline_a --task spec-to-rtl -w 4       # 4 個 worker 並行
python evaluate.py --exp baseline_b --task code-complete-iccad2023
python evaluate.py --exp agent      --task spec-to-rtl --dry-run  # 只列題目，不呼叫 API
python evaluate.py --exp agent      --task spec-to-rtl --no-resume # 強制重跑
```

斷點續跑：預設行為。已有 `result.json` 的題目自動跳過；發生例外的題目不寫 `result.json`，下次執行時會重試。
