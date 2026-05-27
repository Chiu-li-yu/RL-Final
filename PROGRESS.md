# 專題進度紀錄

> 此檔案記錄專題設計討論的決策過程，供最終報告撰寫參考。
> 最後更新：2026-05-26（架構重構）

---

## 階段一：設計釐清（2026-05-25）

### 確認的設計決策

#### 1. 專題方向

- **選定方向**：B — Multi-tool Agent（多工具調用型 Agent）
- **具體類型**：Code Execution Agent
- **核心目標**：Agent 讀入 VerilogEval 題目，透過迭代生成與執行 Verilog 程式碼，最終輸出通過所有 test case 的答案

#### 2. RL 框架定位

- 本系統屬於 **In-Context RL / RLEF（Reinforcement Learning from Execution Feedback）**
- **不做**梯度更新或 policy network 訓練
- RL 框架論述要點：
  - **State**：題目 + 當前程式碼 + error_type + error_log + attempt_number
  - **Action**：fix_code / rewrite_code / call_tool（透過 function calling）
  - **Reward**：Pass = +1；達到上限仍失敗 = 0
  - **Policy**：Gemini（LLM 本身）
  - **Episode**：一道題，最多 3 次 attempt

#### 3. LLM 選擇

- **選定**：Gemini（API 呼叫）
- **理由**：費用低（Flash 版極便宜）、原生支援 function calling、Verilog 生成品質足夠
- **工具介面**：Function Calling（非純文字解析）

#### 4. 工具清單

| 工具             | 實作方式                 | 說明                              |
| ---------------- | ------------------------ | --------------------------------- |
| `compile_tool`   | subprocess 呼叫 iverilog | 回傳 compile log                  |
| `simulate_tool`  | subprocess 呼叫 vvp      | 回傳 simulation log + mismatch 數 |
| `decompose_spec` | 另一個 Gemini call       | 回傳結構化子目標清單              |

- `generate_code` 與 `fix_code` 由 **Gemini 本身**完成（非獨立工具），以保留生成多樣性

#### 5. Agent 決策流程

```
[開始] → generate_code() → compile() + simulate()
  ├─ Pass → [輸出答案]
  ├─ Compile Error → fix_code() → compile() + simulate()
  │     ├─ Pass → [成功]
  │     └─ 失敗 → [放棄]
  └─ Simulation Error → fix_code() → compile() + simulate()
        ├─ Pass → [成功]
        └─ Simulation Error 再次 → decompose_spec() → rewrite_code() → compile() + simulate()
              ├─ Pass → [成功]
              └─ 失敗 → [放棄]
```

#### 6. Error Type 分類

直接複用 VerilogEval 的 `sv-iv-analyze` 腳本邏輯（`analyze_result()` 函式）：

- Compile Error：`S` `C` `e` `0` `n` `w` `m` `p` `c`
- Simulation Error：`R` `T` `r`
- Pass：`.`

#### 7. 評估資料集

- **兩個任務都跑**：`code-complete-iccad2023`（156 題）與 `spec-to-rtl`（156 題）
- 兩者 prompt 格式不同，system prompt 需根據任務切換

#### 8. 評估方法（三組對比實驗）

| 組別           | 設定                                   | 目的                                       |
| -------------- | -------------------------------------- | ------------------------------------------ |
| **Baseline A** | Gemini 單次生成，無 feedback           | 衡量「完全沒有 Agent」                     |
| **Baseline B** | Gemini 跑 3 次獨立生成（互不共享）     | 排除多次嘗試效果，測試 feedback 的獨立價值 |
| **Agent**      | 3 次 + error feedback + decompose_spec | 完整系統                                   |

**附加分析**：按 error type 分類，追蹤每類錯誤在第幾次 attempt 被解決，說明 decompose_spec 的效益分布。

---

## 階段二：環境設定（✅ 完成）

#### 狀態

- [x] Ubuntu WSL 已安裝
- [x] iverilog v12.0 (stable) 已安裝並確認版本
- [x] VerilogEval 第一題驗證通過（Prob001_zero，Mismatches: 0 in 20 samples）
- [x] Python 虛擬環境建立（使用 **uv**，比 pip 快 10-100x）
- [x] `google-genai`（新官方 SDK）安裝並驗證 OK
  - ⚠️ `google-generativeai` 已棄用，改用 `google.genai`
- [x] VS Code WSL Remote 擴充設定完成（`code .` 從 WSL 開啟）

#### 環境重現指令（供 Docker / 新機器使用）

```bash
# 安裝 uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# 建立虛擬環境
uv venv .venv
source .venv/bin/activate

# 安裝套件
uv pip install google-genai python-dotenv
```

#### Python import 範本（新 SDK）

```python
from google import genai
from dotenv import load_dotenv
import os

load_dotenv()
client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
```

#### .gitignore 應包含

```
.venv/
results/
*.vvp
wave.vcd
__pycache__/
.env          ← API key，絕對不能 commit
```

#### 重要發現：編譯需要三個檔案

```bash
iverilog -g2012 -o output.vvp \
  Prob001_zero_ref.sv \   # ← RefModule（正確答案，供 testbench 比對）
  <generated_code>.sv \   # ← TopModule（Gemini 生成的，需命名為 TopModule）
  Prob001_zero_test.sv    # ← testbench
```

#### Pass / Fail 判斷方式

| 情況                         | 判斷             | 處理                        |
| ---------------------------- | ---------------- | --------------------------- |
| iverilog 回傳非零 exit code  | Compile Error    | 把 stderr 餵回 Gemini       |
| vvp 輸出 `Mismatches: 0`     | ✅ Pass          | 結束 episode                |
| vvp 輸出 `Mismatches: N > 0` | Simulation Error | 把 mismatch 訊息餵回 Gemini |

---

## 階段三：核心實作（✅ 完成，2026-05-26）

### 已實作的檔案

#### `agent/error_classifier.py` ✅

簡單三分類：`pass` / `compile_error` / `simulation_error`

```python
classify(compile_returncode: int, combined_output: str) -> tuple[str, int]
```

- `compile_returncode != 0` → `"compile_error"`
- `"TIMEOUT"` in output → `"simulation_error"`
- Regex 解析 `Mismatches: N in M samples` → pass 或 simulation_error

#### `agent/tools.py` ✅

- `compile_and_test(verilog_code, problem_id, task) -> dict`
  - 用 `Path(__file__).parent.parent` 定位 repo 根目錄（WSL 下自動為 `/mnt/d/...`）
  - `tempfile.mkstemp(suffix=".sv")` 產生暫存 generated.sv
  - iverilog compile：`iverilog -g2012 -o out.vvp ref.sv generated.sv test.sv`
  - vvp simulate：`vvp out.vvp`
  - finally 清除暫存檔
- `decompose_spec_internal(problem_description) -> str`
  - 獨立 Gemini API call，回傳 3-5 個子目標

#### `agent/agent.py` ✅

Gemini multi-turn chat + function calling 主迴圈。

- 使用 `client.chats.create()` 管理對話歷史
- `types.Tool(function_declarations=[...])` 定義工具（pydantic 嚴格型別，不可用 flat dict）
- `_safe_text(response)` 安全取得 Gemini 的思考文字
- **4 個 callback 參數**（全部可選，不傳時仍可正常運作）：

| 參數             | 型別                                | 觸發時機                             |
| ---------------- | ----------------------------------- | ------------------------------------ |
| `on_thinking`    | `fn(text)`                          | Gemini 有文字輸出時                  |
| `on_tool_call`   | `fn(name, args, attempt)`           | 工具即將被執行前                     |
| `on_tool_result` | `fn(name, result, attempt)`         | 工具執行完畢後                       |
| `on_checkpoint`  | `fn(attempt, result, code) -> bool` | compile_and_test 後，回傳 False 中止 |

#### `run.py` ✅（新增，2026-05-26）

互動式 CLI 前端，參考 `learn-claude-code` 的 agent loop 模式設計。

功能：

- ANSI 彩色輸出（Gemini 思考文字、工具呼叫、pass/fail 結果）
- 每次 compile_and_test 後自動儲存程式碼：`outputs/agent/{task}/{problem_id}/attempt_N.sv`
- 人工介入點（on_checkpoint）：`[Enter] 繼續 / a 中止 / v 查看完整 log / c 查看完整程式碼`
- 執行結果存 `outputs/agent/{task}/{problem_id}/result.json`

執行方式：

```bash
python run.py                              # REPL 模式（可連續測試多題）
python run.py Prob001_zero                 # 單題（預設 spec-to-rtl）
python run.py Prob001_zero code-complete-iccad2023
```

輸出目錄結構：

```
outputs/
  agent/spec-to-rtl/
    Prob001_zero/
      attempt_1.sv    ← simulation_error（自動儲存）
      attempt_2.sv    ← PASS（最終答案）
      result.json     ← {"passed": true, "attempts": 2, "task": "spec-to-rtl", "experiment": "agent"}
```

### 端對端驗證結果（Prob001_zero）

```
attempt 1: always @(*) zero = 0 → simulation_error（Gemini 自主判斷改法）
attempt 2: assign zero = 1'b0   → PASS ✅
```

- Gemini 接收到第一次的 simulation_error feedback，自主修正語法，第二次即通過
- 這正是 RLEF / In-Context RL 的核心行為展示

---

## 階段三·五：架構重構（2026-05-26）

### 動機

核心實作跑通後，做了一輪架構審查，消除 4 個設計摩擦點，讓新接觸專題的人能更快看懂各模組的職責。

### 改動一：刪除 `agent/error_classifier.py`

**問題**：`error_classifier.py` 只有一個函式 `classify()`，唯一的呼叫者是 `tools.py`。這是一個淺層傳遞模組——刪除它不會讓複雜度消失，只是讓它集中到正確的地方。

**做法**：將 `classify()` 改名為 `_classify()`（私有），直接內嵌進 `tools.py`。刪除 `agent/error_classifier.py`。

**效果**：分類邏輯與使用它的工具在同一個地方，`from agent.error_classifier import classify` 的 import 消失。

---

### 改動二：`agent.py` 加入 `Episode` dataclass

**問題**：`run_agent()` 迴圈內有三個散落的局部變數（`attempts`、`final_code`、`last_result`），代表「單題執行狀態」卻沒有名字。

**做法**：

```python
@dataclass
class Episode:
    problem_id: str
    attempts:   int  = 0
    final_code: str  = ""
    last_result: dict = field(default_factory=lambda: {...})

    def to_result(self) -> dict:
        """轉換為 run_agent() 的回傳格式。"""
        ...
```

迴圈內改為 `ep.attempts`、`ep.final_code`、`ep.last_result`；函式最後改為 `return ep.to_result()`。

**效果**：「一道題的執行狀態」有了明確的型別；`to_result()` 是唯一定義回傳格式的地方。

---

### 改動三：新建 `agent/dataset.py`

**問題**：`run.py` 硬編了資料集目錄路徑和輸出路徑，未來的 `evaluate.py` 也需要相同的路徑知識，等於讓兩個呼叫者各自維護相同的目錄結構。

**做法**：抽出 `agent/dataset.py`，提供以下函式：

| 函式                                                             | 說明                                          |
| ---------------------------------------------------------------- | --------------------------------------------- |
| `load_problem(problem_id, task) -> str`                          | 讀取題目自然語言描述                          |
| `list_problems(task) -> list[str]`                               | 回傳排序後的 156 個 problem ID                |
| `result_exists(problem_id, task, experiment) -> bool`            | 檢查 result.json 是否存在（斷點續跑用）       |
| `save_code(problem_id, attempt, code, task, experiment) -> Path` | 儲存 `outputs/{exp}/{task}/{id}/attempt_N.sv` |
| `save_result(problem_id, result, task, experiment) -> Path`      | 儲存 `outputs/{exp}/{task}/{id}/result.json`  |

`save_result` 自動將 `task` 與 `experiment` 注入 JSON，方便跨組分析。

`run.py` 移除 `_save_code()`、`_save_result()`、`_PROMPT_DIRS`，改為 `from agent.dataset import load_problem, save_code, save_result`。

**效果**：資料集目錄結構只有 `dataset.py` 知道；`evaluate.py` 直接 import，不需重複路徑邏輯。

---

### 改動四：`decompose_spec_internal` 移出 `tools.py`

**問題**：`tools.py` 的職責是「subprocess 呼叫」（iverilog / vvp）；`decompose_spec_internal` 是 Gemini LLM 呼叫，放在這裡讓模組有兩種不同性質的依賴。

**做法**：將 `decompose_spec_internal` 移到 `agent.py`，改名為 `_decompose_spec(problem_description, model)`。`tools.py` 不再 import `google.genai`。

**效果**：

```
tools.py  → 只管 subprocess（iverilog + vvp）
agent.py  → compile_and_test dispatch + _decompose_spec（兩個都是 Gemini 對話迴圈的工具）
```

---

### 重構後各模組單一職責

```
agent/
  tools.py    — subprocess 工具（iverilog + vvp）
  dataset.py  — 檔案 I/O（題目讀取、outputs/ 寫入）  ← 新增
  prompts.py  — system prompt 文字
  agent.py    — Gemini 對話迴圈 + function dispatch
run.py        — 顯示與互動（callbacks + REPL）
```

---

## 階段四：實作準備（2026-05-25，距離 6/2 剩 8 天）

### 檔案結構已完成

```
agent/
├── __init__.py
├── tools.py           ← 【優先】待實作：compile_and_test()
├── agent.py           ← 待實作：Gemini 多輪 chat 主迴圈
├── prompts.py         ✅ 已準備：system prompt 範本
└── error_classifier.py ← 待實作：移植 sv-iv-analyze 邏輯

evaluate.py            ← 待實作：跑全部 156 題
requirements.txt       ✅ 已建立
.env                   ← 你的 GEMINI_API_KEY
test_gemini_basic.py   ✅ 已準備：測試 function calling 用
```

### 任務分配與優先順序

**【TODAY - 5/26】**

#### 戴庭涵：實作 `agent/tools.py::compile_and_test()`

最關鍵的一步，其他人都在等它。

**輸入**：

- `verilog_code`：Gemini 生成的完整 Verilog 程式碼（含 `module TopModule`）
- `problem_id`：題目 ID（例如 `"Prob001_zero"`）
- `task`：任務類型（`"code-complete-iccad2023"` 或 `"spec-to-rtl"`）

**輸出**：

```python
{
    "passed": True/False,
    "error_type": ".",  # 見下方分類表
    "error_log": "Mismatches: 0 in 20 samples",
    "mismatch_count": 0
}
```

**實作步驟的偽代碼**：

```python
def compile_and_test(verilog_code, problem_id, task):
    # 1. 決定資料集根目錄
    dataset_dir = f"verilog-eval/dataset_{task}/{problem_id}"
    ref_file = f"{dataset_dir}/{problem_id}_ref.sv"
    test_file = f"{dataset_dir}/{problem_id}_test.sv"

    # 2. 把 verilog_code 寫到暫存檔
    with open("/tmp/generated.sv", "w") as f:
        f.write(verilog_code)

    # 3. 執行 iverilog 編譯
    result = subprocess.run([
        "iverilog", "-g2012", "-o", "/tmp/out.vvp",
        ref_file, "/tmp/generated.sv", test_file
    ], capture_output=True, text=True)

    if result.returncode != 0:
        # 編譯失敗，解析 stderr → error_type（S, C, e, 等）
        return {
            "passed": False,
            "error_type": classify_compile_error(result.stderr),
            "error_log": result.stderr[:500],  # 截斷前 500 字
            "mismatch_count": 0
        }

    # 4. 執行 vvp 模擬
    result = subprocess.run(["vvp", "/tmp/out.vvp"],
                          capture_output=True, text=True)

    # 5. 解析 vvp 輸出
    if "Mismatches: 0" in result.stdout:
        return {"passed": True, "error_type": ".", ...}
    else:
        # 提取 mismatch 數
        mismatch = extract_mismatch_count(result.stdout)
        return {
            "passed": False,
            "error_type": "R",  # Runtime error
            "error_log": result.stdout[:500],
            "mismatch_count": mismatch
        }
```

**需要用到的工具**：

- `subprocess.run()` - 呼叫 iverilog / vvp
- 正則表達式 - 解析錯誤訊息和 mismatch 數

**參考**：`verilog-eval/scripts/sv-iv-analyze` 的 `analyze_result()` 函式（看它怎麼解析 log）

---

#### 邱立宇：測試 Gemini function calling

在 compile_and_test 完成前，先驗證 Gemini 的 tool calling 能正常運作。

```bash
source .venv/bin/activate
export GEMINI_API_KEY="你的key"
python test_gemini_basic.py
```

預期輸出：`✅ Function calling 正常運作`

然後開始設計 `agent/agent.py` 的框架：

```python
def run_agent(problem: str, task: str):
    """主 Agent 迴圈"""
    client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

    # 初始化 chat session，帶上 tools
    chat = client.chats.create(
        model="gemini-1.5-flash",
        system_prompt=get_system_prompt(task),
        tools=[compile_and_test_schema, decompose_spec_schema]
    )

    # 第一個 message：送入題目
    response = chat.send_message(f"題目：{problem}")

    # 處理 Gemini 的 function calls
    # TODO: 實作迴圈邏輯，處理 attempt 計數、error 判斷等
```

---

### Error Type 分類表（參考 sv-iv-analyze）

| 代碼 | 意思                         | 來源                                               |
| ---- | ---------------------------- | -------------------------------------------------- |
| `.`  | Pass（所有 test case 通過）  | vvp 輸出 "Mismatches: 0"                           |
| `S`  | Syntax Error                 | iverilog stderr 含 "syntax error"                  |
| `C`  | Compiler Error（通用）       | iverilog stderr 含 "error" 但不是上面的特定類型    |
| `e`  | Explicit Cast Required       | iverilog stderr 含 "explicit cast"                 |
| `0`  | Sized Numeric Constant Error | iverilog stderr 含 "size greater than zero"        |
| `n`  | No Sensitivities Warning     | iverilog stderr 含 "no sensitivities"              |
| `w`  | Declared as Wire             | iverilog stderr 含 "declared as wire"              |
| `m`  | Unknown Module Type          | iverilog stderr 含 "Unknown module type"           |
| `p`  | Unable to Bind Wire/Reg      | iverilog stderr 含 "Unable to bind"                |
| `c`  | Unable to Bind `clk`         | iverilog stderr 含 "Unable to bind wire/reg `clk`" |
| `R`  | Runtime Error（simulation）  | vvp 執行成功但 "Mismatches: N > 0"                 |
| `T`  | Timeout                      | iverilog stderr 含 "TIMEOUT"                       |

---

### 5/26 日誌檢查清單

- [x] 戴庭涵：`compile_and_test()` 實作完成，能成功編譯並模擬一道題
- [x] 邱立宇：`test_gemini_basic.py` 執行成功，確認 function calling 動作正常
- [x] `agent/error_classifier.py` 完成
- [x] `agent/agent.py` 完成（含 callback 介面）
- [x] `run.py` 互動式 CLI 完成
- [x] 端對端 Prob001_zero 驗證通過
- [x] GitHub commit：`"feat: 核心實作完成，工具層 + agent loop + 互動式 CLI"`

#### 執行環境

- Python 主程式跑在 **WSL Ubuntu**
- 最終用 **Docker** 包起來交付
- iverilog 直接 subprocess 呼叫（不需透過 `wsl` 前綴）

#### 檔案結構

```
專題根目錄/
├── agent/
│   ├── agent.py            ← 主迴圈：Gemini 多輪對話 + function calling
│   ├── tools.py            ← compile_and_test, decompose_spec 實作
│   ├── error_classifier.py ← 移植 sv-iv-analyze 的 analyze_result()
│   └── prompts.py          ← system prompt（按任務類型切換）
├── evaluate.py             ← 跑全部 156 題，收集結果
├── results/                ← 每題的結果與 log
├── Dockerfile
├── requirements.txt
└── verilog-eval/
```

#### 對話方式

- **多輪對話（chat session）**：Gemini 保留完整對話歷史自主決策
- 每次 attempt token 累積，但最多 3 次，最壞情況約 1300 tokens/題，費用極低（$0.1 美元以內）
- error log 截斷至前 **50 行**，避免無用資訊干擾

#### Function Calling Schema

```python
compile_and_test = {
    "name": "compile_and_test",
    "description": "編譯並模擬 Verilog 程式碼，回傳是否通過測試及錯誤訊息",
    "parameters": {
        "type": "object",
        "properties": {
            "verilog_code": {"type": "string", "description": "完整的 TopModule Verilog 程式碼"}
        },
        "required": ["verilog_code"]
    }
}

decompose_spec = {
    "name": "decompose_spec",
    "description": "將題目規格分解成子目標清單，在邏輯錯誤多次修改無效時使用",
    "parameters": {
        "type": "object",
        "properties": {
            "problem_description": {"type": "string", "description": "原始題目敘述"}
        },
        "required": ["problem_description"]
    }
}
```

#### decompose_spec 觸發方式

- **方式 A：Gemini 自主決定**（選定）
- System prompt 提示 Gemini：「當因邏輯錯誤失敗超過一次時，請先呼叫 decompose_spec」
- Gemini 作為 policy 自主選擇 action，符合 RL 框架論述

### System Prompt 設計

**code-complete 版本：**

```
你是一個 Verilog RTL 設計師。
你的任務是根據題目描述，補全給定的 Verilog module 內部邏輯。

規則：
- 輸出必須是完整的 module，包含 module TopModule (...) 到 endmodule
- module 的 port 介面已在題目中給定，不得修改
- 只使用 logic 宣告，不使用 wire 或 reg
- 組合邏輯使用 always @(*)，不寫 sensitivity list
- 同步 reset 不要在 sensitivity list 裡放 posedge reset

完成程式碼後，立刻呼叫 compile_and_test 工具驗證。
若因邏輯錯誤失敗超過一次，請先呼叫 decompose_spec 分析題目，再重新撰寫。
```

**spec-to-rtl 版本：**

```
你是一個 Verilog RTL 設計師。
你的任務是根據自然語言規格，從零設計並實作完整的 Verilog module。

規則：
- 輸出必須是完整的 module，包含 port 宣告到 endmodule，module 名稱必須是 TopModule
- 只使用 logic 宣告，不使用 wire 或 reg
- 組合邏輯使用 always @(*)，不寫 sensitivity list
- 同步 reset 不要在 sensitivity list 裡放 posedge reset

完成程式碼後，立刻呼叫 compile_and_test 工具驗證。
若因邏輯錯誤失敗超過一次，請先呼叫 decompose_spec 分析題目，再重新撰寫。
```

> 規則來源：VerilogEval `sv-generate` 腳本的 `prompt_rules_suffix`，對應 `sv-iv-analyze` 的各 error code

### decompose_spec 內部實作

- 另一個獨立的 Gemini API call（非主 chat session）
- Prompt：`"請將以下 Verilog 題目分解成 3-5 個具體子目標：\n{problem_description}"`
- 回傳子目標清單字串給主 chat session 作為 tool result

### 結果儲存格式（每題一個 JSON）

```json
{
  "problem": "Prob001_zero",
  "task": "code-complete-iccad2023",
  "result": "pass",
  "attempts": 2,
  "error_types": ["S", "."],
  "used_decompose_spec": false,
  "final_code": "module TopModule ..."
}
```

### 分工

| 檔案                                                 | 負責人 |
| ---------------------------------------------------- | ------ |
| `agent/tools.py`（compile_and_test、decompose_spec） | 戴庭涵 |
| `agent/error_classifier.py`（移植 sv-iv-analyze）    | 戴庭涵 |
| `Dockerfile`                                         | 戴庭涵 |
| `agent/agent.py`（Gemini 多輪對話主迴圈）            | 邱立宇 |
| `agent/prompts.py`（system prompt）                  | 邱立宇 |
| `evaluate.py`（跑 156 題、存 JSON）                  | 邱立宇 |

---

## 剩餘行動清單（2026-05-26，距離 6/2 剩 7 天）

### 已完成（5/25–5/26）✅

- [x] 設計討論完畢、決策記錄於 CONTEXT.md / PROGRESS.md
- [x] 環境設定（WSL、iverilog、uv、google-genai）
- [x] `agent/tools.py`（compile_and_test；`_classify` 內嵌，`decompose_spec` 已移出）
- [x] `agent/dataset.py`（新增；load_problem / save_code / save_result）
- [x] `agent/prompts.py`
- [x] `agent/agent.py`（Gemini multi-turn + function calling + callbacks + `Episode` dataclass）
- [x] `run.py`（互動式 CLI，純顯示層，I/O 委派給 dataset.py）
- [x] 端對端驗證（Prob001_zero，2 次嘗試通過）
- [x] 架構重構（4 項改善，消除 error_classifier 淺層模組，職責分離）

### 已完成（5/27）✅

- [x] **細粒度 error classification**：`tools.py` 的 `_classify` 從三分類升級為 13-code，完整移植 VerilogEval `sv-iv-analyze` 的 `analyze_result()` 邏輯，結果可直接與公開基準比較
  - compile phase：`_classify_compile(log)` → S / e / 0 / n / w / m / c / p / C
  - sim phase：`_classify_sim(sim_log, verilog_code)` → . / R / T / r
  - 新增 Python-level `TimeoutExpired` 捕捉（回傳 `T`）
  - 新增公開常數 `COMPILE_ERROR_CODES`、`SIM_ERROR_CODES`、`PASS_CODE`（供 evaluate.py 使用）
- [x] **API Retry 機制**：`agent.py` 新增 `_with_retry()`，指數退避處理 429 / 503 / 504，所有 `chat.send_message()` 和 `generate_content()` 呼叫均已包裝
- [x] **整合測試腳本** `test_tools.py`：Section 1 單元測試（mock log，不需 iverilog）+ Section 2 整合測試（需 WSL iverilog），覆蓋 9 種 error code 的端對端觸發
- [x] **`dataset.py` 擴充**（evaluate.py 前置準備）：
  - 新增 `list_problems(task)` → 回傳排序後 156 個 problem ID
  - 新增 `result_exists(problem_id, task, experiment)` → 斷點續跑用
  - `save_code` / `save_result` 新增 `task`, `experiment` 參數
  - 輸出目錄改為三層結構：`outputs/{experiment}/{task}/{problem_id}/`
  - `result.json` 自動注入 `task` 與 `experiment` 欄位
  - `run.py` 同步更新：一律以 `experiment="agent"` 儲存

### 5/27–5/28

- [x] 整合測試腳本（test_tools.py）
- [x] 實作 `evaluate.py`：批次跑全部 156 題，收集結果 JSON
  - agent / baseline_a / baseline_b 三組執行器
  - `ThreadPoolExecutor` 並行執行，`--workers` 可調
  - `result_exists()` 斷點續跑，`--no-resume` 可強制重跑
  - `_Progress` 執行緒安全進度追蹤，逐行輸出 + 最終摘要
  - `--dry-run` 列出待執行題目不呼叫 API

### 5/29–5/30

- [ ] 跑完整實驗（3 組 × 兩種 task × 156 題）
  - `python evaluate.py --exp agent --task spec-to-rtl`
  - `python evaluate.py --exp baseline_a --task spec-to-rtl`
  - `python evaluate.py --exp baseline_b --task spec-to-rtl`
  - code-complete-iccad2023 同上三組

### 5/31–6/01

- [ ] 分析結果，製作圖表（pass rate 比較、error type 分布、attempt 分布）
- [ ] 撰寫書面報告

### 6/02

- [ ] Docker 容器化
- [ ] 提交
