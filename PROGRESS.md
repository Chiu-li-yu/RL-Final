# 專題進度紀錄

> 此檔案記錄專題設計討論的決策過程，供最終報告撰寫參考。
> 最後更新：2026-05-25

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

## 階段三：程式架構設計（2026-05-25）

### 確認的架構決策

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

## 立即行動清單（2026-05-25，距離 6/2 剩 8 天）

### 今天（5/25）

- [x] 設計討論完畢
- [ ] 在 GitHub 建 public repository 並 push 現有檔案
- [ ] WSL 安裝 Python 依賴：`pip install google-generativeai`
- [ ] 取得 Gemini API key（Google AI Studio 免費申請）

### 5/26–5/27（戴庭涵）

- [ ] 實作 `agent/tools.py`：`compile_and_test()` 函式
  - 接收 verilog_code 字串，寫入暫存 .sv 檔
  - subprocess 呼叫 `iverilog -g2012 -o /tmp/out.vvp ref.sv generated.sv test.sv`
  - 解析 exit code 和 stderr → 判斷 compile error
  - 若 compile 成功，呼叫 `vvp /tmp/out.vvp` → 解析 "Mismatches: N"
  - 回傳 `{"error_type": ".", "error_log": "...", "passed": True/False}`
- [ ] 實作 `agent/error_classifier.py`：移植 `sv-iv-analyze` 的 `analyze_result()` 邏輯

### 5/26–5/27（邱立宇）

- [ ] 實作 `agent/prompts.py`：兩版 system prompt
- [ ] 實作 `agent/agent.py`：Gemini 多輪 chat + function calling 主迴圈
  - 初始化 chat session with tools
  - 送入題目，等待 Gemini function call
  - 處理 compile_and_test / decompose_spec 的呼叫
  - 最多 3 次 attempt 後終止

### 5/28–5/29

- [ ] 整合測試：跑 5 題確認整個流程通
- [ ] 實作 `evaluate.py`：跑全部 156 題，存 JSON

### 5/30–5/31

- [ ] 跑完整實驗：Agent + Baseline A + Baseline B
- [ ] 分析結果，製作圖表

### 6/01–6/02

- [ ] 撰寫書面報告
- [ ] Docker 容器化
- [ ] 提交
