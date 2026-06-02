# Error Fix Log

開發過程中遇到的錯誤及修復方式，供後續參考。

---

## #1 — `cannot import name 'run_agent' from 'agent'`

**時間**：agent.py 完成後初次測試  
**發生位置**：`TEST.py` 第 1 行

### 錯誤訊息

```
ImportError: cannot import name 'run_agent' from 'agent'
```

### 原因

`agent/` 是一個 Python package（有 `__init__.py`），但 `__init__.py` 是空的，不 export 任何東西。  
`run_agent()` 定義在 `agent/agent.py` 裡，不在 `agent/__init__.py` 裡。

```
agent/
  __init__.py   ← 空的，沒有 export run_agent
  agent.py      ← run_agent() 在這裡
```

`from agent import run_agent` → Python 查 `agent/__init__.py`，找不到 → 報錯。

### 修復

```python
# ❌ 錯誤
from agent import run_agent

# ✅ 正確：指定子模組路徑
from agent.agent import run_agent
```

---

## #2 — `ValidationError: 8 validation errors for GenerateContentConfig`（tools 格式錯誤）

**時間**：#1 修正後，第二次執行  
**發生位置**：`agent/agent.py` → `types.GenerateContentConfig(tools=_TOOLS)`

### 錯誤訊息

```
pydantic_core._pydantic_core.ValidationError: 8 validation errors for GenerateContentConfig
tools.0.Tool.name
  Extra inputs are not permitted [type=extra_forbidden, ...]
tools.0.Tool.description
  Extra inputs are not permitted [type=extra_forbidden, ...]
tools.0.Tool.parameters
  Extra inputs are not permitted [type=extra_forbidden, ...]
tools.0.callable
  Input should be callable [type=callable_type, ...]
... (同樣錯誤重複出現在 tools.1)
```

### 原因

`GenerateContentConfig` 是 pydantic 模型，其 `tools` 欄位只接受：

- `types.Tool` 物件
- Python callable（函式）

原本傳入的是 flat dict `{"name": ..., "description": ..., "parameters": ...}`，這是 **OpenAI / 舊版 google.generativeai 的格式**，不符合新版 `google.genai` SDK 的 pydantic 型別定義。

pydantic 嘗試將 dict 解析為 `Tool`，但 `Tool` 的欄位是 `function_declarations`，沒有 `name`、`description`、`parameters`，所以全部報 `Extra inputs are not permitted`。

#### 為什麼 `test_gemini_basic.py` 的 dict 格式可以跑？

```python
# test_gemini_basic.py — 這樣可以
client.models.generate_content("...", tools=[{"name": ..., ...}])
```

`generate_content()` 直接接受 dict 作為 tools 參數，**繞過了 pydantic 驗證**。  
但 `chats.create(config=GenerateContentConfig(...))` 走的是 pydantic 嚴格型別，dict 不被接受。

#### 兩種呼叫方式的差異

| 呼叫方式                              | tools 格式                    |
| ------------------------------------- | ----------------------------- |
| `generate_content(..., tools=[dict])` | ✅ dict 可以（不走 pydantic） |
| `GenerateContentConfig(tools=[dict])` | ❌ 必須用 `types.Tool` 物件   |

### 修復

```python
# ❌ 錯誤：flat dict 格式（OpenAI / 舊版格式）
_TOOLS = [
    {
        "name": "compile_and_test",
        "description": "...",
        "parameters": {
            "type": "object",
            "properties": {"verilog_code": {"type": "string"}},
            "required": ["verilog_code"],
        },
    }
]

# ✅ 正確：使用 types.Tool / FunctionDeclaration / Schema
from google.genai import types

_TOOLS = types.Tool(
    function_declarations=[
        types.FunctionDeclaration(
            name="compile_and_test",
            description="...",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "verilog_code": types.Schema(
                        type=types.Type.STRING,
                        description="完整的 TopModule Verilog 程式碼",
                    )
                },
                required=["verilog_code"],
            ),
        ),
        # ... 其他 tool
    ]
)

# config 傳入時用 list 包裝
config = types.GenerateContentConfig(
    system_instruction=system_prompt,
    tools=[_TOOLS],   # ← list of Tool 物件
)
```

### 關鍵型別對照

| JSON Schema 型別 | `types.Type` 枚舉值  |
| ---------------- | -------------------- |
| `"object"`       | `types.Type.OBJECT`  |
| `"string"`       | `types.Type.STRING`  |
| `"number"`       | `types.Type.NUMBER`  |
| `"integer"`      | `types.Type.INTEGER` |
| `"boolean"`      | `types.Type.BOOLEAN` |
| `"array"`        | `types.Type.ARRAY`   |

---

## #3 — `TypeError: run_agent() got an unexpected keyword argument 'on_thinking'`

**時間**：`run.py` 建立後初次執行  
**發生位置**：`run.py` → `run_agent(..., on_thinking=_on_thinking, ...)`

### 錯誤訊息

```
TypeError: run_agent() got an unexpected keyword argument 'on_thinking'
```

### 原因

`run.py` 呼叫 `run_agent()` 並傳入 4 個 callback 參數（`on_thinking`、`on_tool_call`、`on_tool_result`、`on_checkpoint`），但 `agent/agent.py` 的函式簽名不包含這些參數。

在 IDE 中同時開啟同一檔案時，Claude 寫入含 callback 的新版 `agent.py` 後，IDE 又以舊版覆蓋存回（儲存競爭），導致 callback 參數整段消失。

### 修復

重新將 4 個 callback 參數加回 `run_agent()` 的函式簽名，並補上 `from typing import Callable` 與 `_safe_text()` helper：

```python
from typing import Callable

def run_agent(
    ...,
    on_thinking:    Callable[[str], None]            | None = None,
    on_tool_call:   Callable[[str, dict, int], None] | None = None,
    on_tool_result: Callable[[str, dict, int], None] | None = None,
    on_checkpoint:  Callable[[int, dict, str], bool] | None = None,
) -> dict:
```

### 預防方式

- 新增跨檔案介面（如 callback 參數）後，先在 terminal 執行一次 `python -c "from agent.agent import run_agent; import inspect; print(inspect.signature(run_agent))"` 確認簽名正確，再呼叫
- 避免在 Claude 正在寫入某檔案期間，從 IDE 同步儲存同一檔案

---

## #4 — Agent 連續三次 compile_error 且無法自我修復（Prob156 enum + 三元運算子）

**時間**：端對端測試 Prob156_review2015_fancytimer  
**發生位置**：`agent/agent.py` 主迴圈，3 次 compile_and_test 全部回傳 `compile_error`

### 錯誤訊息

```
/tmp/tmpXXXXXX.sv:67: error: This assignment requires an explicit cast.
/tmp/tmpXXXXXX.sv:68: error: This assignment requires an explicit cast.
/tmp/tmpXXXXXX.sv:69: error: This assignment requires an explicit cast.
```

### 問題程式碼（三次都出現相同模式）

```verilog
always @(*) begin
    next_state = state;
    case (state)
        S_S1:   next_state = data ? S_S11 : S_IDLE;   // ← 錯誤在這
        S_S11:  next_state = data ? S_S11 : S_S110;
        S_S110: next_state = data ? S_LOAD : S_IDLE;
    endcase
end
```

### 原因

iverilog `-g2012` 模式下，三元運算子 `?:` 的結果會被推導為底層型別 `logic [2:0]`（enum 的底層型別），而非 `state_t`。將 `logic [2:0]` 賦值給 `state_t` 需要明確 cast，否則回報 `This assignment requires an explicit cast`。

**這是 iverilog 特有行為**，不是一般 SystemVerilog 規範問題。

### 為什麼 Gemini 無法自我修復

錯誤訊息「This assignment requires an explicit cast」沒有指出是**三元運算子**造成的，只說需要 explicit cast。Gemini 連續三次猜錯修法：

| 嘗試 | Gemini 的猜測                               | 實際效果 |
| ---- | ------------------------------------------- | -------- |
| 1    | 原始寫法（無修改）                          | 錯誤相同 |
| 2    | 為 integer literal 加位元寬 `3'd0`, `16'd0` | 錯誤相同 |
| 3    | 為 enum 成員加顯式數值 `S_IDLE = 3'd0`      | 錯誤相同 |

Gemini 從未推斷出「三元運算子本身是問題根源」。

### 修復方式

```verilog
// ❌ 錯誤：enum 型別 case 裡用三元運算子
S_S1:   next_state = data ? S_S11 : S_IDLE;

// ✅ 方法 A：改用 if-else（推薦，最保險）
S_S1:   if (data) next_state = S_S11;
        else      next_state = S_IDLE;

// ✅ 方法 B：顯式 cast
S_S1:   next_state = state_t'(data ? S_S11 : S_IDLE);
```

### 長期修法（待實作）

在 `agent/prompts.py` 的兩個 system prompt 加入規則：

```
- 在 case statement 中不使用三元運算子（? :）做 state 轉換，改用 if-else 分支
  （iverilog -g2012 模式下，enum 型別的三元運算子結果會被推導為底層 logic 型別，需要 explicit cast）
```

---

## #5 — `get_interface` 工具依賴 benchmark ground truth，不適用真實場景（設計缺陷）

**時間**：2026-05-28，架構審查時發現  
**發生位置**：`agent/tools.py::get_interface()`，`spec-to-rtl` prompt 步驟一

### 問題描述

`get_interface` 工具從 `ref.sv`（VerilogEval 的參考答案）讀取 TopModule 的 port 介面宣告。在 benchmark 中，這讓 LLM 可以直接得到「正確」的 port 名稱，避免觸發 `p`/`c` 類 compile error。

```python
# tools.py（舊版）— 直接讀 ground truth
ref_sv = dataset_dir / f"{problem_id}_ref.sv"
content = ref_sv.read_text(encoding="utf-8")
```

### 為什麼這是問題

| 情境                  | `get_interface` 可用？ | 說明                          |
| --------------------- | ---------------------- | ----------------------------- |
| VerilogEval benchmark | ✅ 可用                | ref.sv 存在                   |
| 真實 RTL 設計         | ❌ 不可用              | 沒有 ref.sv，介面要從規格設計 |

使用此工具會讓系統在 benchmark 上比真實場景多一個優勢：LLM 知道正確 port 名稱，`p`/`c` 錯誤比例會被人工壓低，不反映真實設計難度。

對於 `code-complete-iccad2023`，port 介面已在問題描述中給出（`_ifc.txt`），呼叫 `get_interface` 只是重讀已知資訊，同樣沒有必要。

### 修復

移除 `get_interface` 工具，同時更新 `spec-to-rtl` prompt：

```
# 舊 prompt（三步驟，step 1 依賴 ground truth）
1. 先呼叫 get_interface 取得正確的 port 介面宣告
2. ...

# 新 prompt（從規格自行設計介面）
- port 名稱與方向必須與題目規格完全一致
```

### 影響

移除後，`p`/`c` 類 compile error 出現率可能上升。這是正確的行為——它反映了 LLM 真正的 spec 理解能力，而非依賴 ground truth 的人工優勢。在報告中可作為「benchmark 設定的 limitation」討論點。

---

## #6 — `TypeError: Part.from_text() takes 1 positional argument but 2 were given`

**時間**：2026-05-30，嘗試將 user_hint 以 text Part 附加到 tool_results 時  
**發生位置**：`agent/agent.py` → `types.Part.from_text(text_str)`

### 錯誤訊息

```
TypeError: Part.from_text() takes 1 positional argument but 2 were given
```

### 原因

在此版本的 `google-genai` SDK 中，`types.Part.from_text()` **不是 classmethod**，而是 instance method——`self` 被當作第一個參數，字串內容被當作第二個，因此報 "2 were given"。

### 修復

```python
# ❌ 錯誤：from_text() 在此 SDK 版本不是 classmethod
types.Part.from_text(f"[使用者補充修改方向] {hint}")

# ✅ 正確：用 keyword argument 建構
types.Part(text=f"[使用者補充修改方向] {hint}")
```

### 後續設計調整

發現即使使用 `types.Part(text=...)` 與 function_response Parts 混合在同一個 `send_message()`，Gemini API 不保證會讀取 text Part（可能只處理 function_response）。

最終改為**將 user_hint 嵌入 function response dict 的 `user_direction` 欄位**：

```python
result = dict(result)
result["user_direction"] = user_hint
# 然後 Part.from_function_response("compile_and_test", response=result)
```

這樣 agent 在讀取工具回傳值時一定會看到 hint，且只需一次 API call，不會在 chat history 留下懸空的 R1 response。

---

## #7 — user_hint 注入造成 chat history 不一致

**時間**：2026-05-30，分析 `on_checkpoint` 的 hint 注入邏輯時發現  
**發生位置**：`agent/agent.py` → `run_agent()` 末尾的 hint 注入段

### 問題描述

原本的 hint 注入流程：

```python
response = chat.send_message(tool_results)  # → Gemini 生成 R1（已包含新的 compile 呼叫）
if _user_hint:
    response = chat.send_message(_user_hint)  # → Gemini 生成 R2
```

這造成 chat history 中 R1 懸在沒有對應 compile 結果的狀態：

```
3. user:  [tool result: 編譯失敗]
4. model: [R1: 新程式碼 + compile_and_test 呼叫]  ← 永遠不被執行
5. user:  [user hint]
6. model: [R2: 根據 R1 + hint 再次決策]
```

R1 多消耗一次 API call，且 R2 看到自己在 R1 中已呼叫 compile 但拿不到結果，行為不確定。

### 修復

將 hint 嵌入 `compile_and_test` 的 function response `user_direction` 欄位（見 #6），tool_results 和 hint 在同一個 `send_message()` call 中一起送出，只生成一個 response：

```
3. user:  [tool result: 編譯失敗, user_direction: "請確認 reset 初始值"]
4. model: [R1: 根據 compile 結果 + hint 決策]  ← 唯一的 response
```

---

## #8 — Ablation study prompt 提及不可呼叫的工具（設計缺陷）

**時間**：2026-05-30，程式碼審查時發現  
**發生位置**：`agent/prompts.py` 的 base prompt + `agent/agent.py::run_agent()` 的字串拼接

### 問題描述

`SPEC_TO_RTL_PROMPT` / `CODE_COMPLETE_PROMPT` 硬寫了所有可選工具的說明：

```
其他可用工具：
- decompose_spec：若題目複雜度高且多次修改仍無效時，可呼叫並用於分析。
- get_debug_hints：遇到出現一次以上的錯誤類型...
```

`run_agent()` 也硬寫：

```python
system_prompt = (
    task.system_prompt
    + f"\n每題僅有 {max_attempts} 次作答機會，請善用工具(decompose_spec、get_debug_hints)..."
)
```

在 `no_debug_hints` / `no_decompose` / `no_helper_tools` 等實驗中，被停用的工具不在 `function_declarations` 內，模型無法呼叫，但 prompt 仍叫它去用。模型在 context 中「想要」使用不存在的工具，影響生成行為，使各 ablation 組的比較基準不乾淨。

### 修復

新增 `build_system_prompt(task, enabled_tools, max_attempts) -> str`（`agent/prompts.py`）：

```python
_OPTIONAL_TOOL_DESCRIPTIONS: dict[str, str] = {
    "decompose_spec": "...",
    "get_debug_hints": "...",
}

def build_system_prompt(task, enabled_tools, max_attempts) -> str:
    active = [t for t in _OPTIONAL_TOOL_DESCRIPTIONS
              if enabled_tools is None or t in enabled_tools]
    parts = [task.system_prompt]
    if active:
        # 附加工具說明段落 + 善用工具指示句（只列 active 工具）
    else:
        # 只附加次數限制，不提任何可選工具
    return "\n".join(parts)
```

`agent/agent.py` 改為一行呼叫：`system_prompt = build_system_prompt(task, enabled_tools, max_attempts)`

---

## #9 — `evaluate.py` 工具呼叫 avg 分母排除 skipped 題目

**時間**：2026-05-30，程式碼審查時發現  
**發生位置**：`evaluate.py::_Progress.finish()`

### 問題描述

`update()` 對所有有效 result（含 `was_skipped=True`）均累計 `total_decompose` / `total_debug_hints`，因此 total 包含所有題目。但 `finish()` 的平均分母：

```python
done_nonzero = self.done - self.skipped - self.errors  # ← skipped 被排除
avg = self.total_decompose / done_nonzero
```

total 含 skipped，avg 分母不含 skipped，造成 avg 數字偏高（尤其 resume 執行大量題目已跳過時）。

### 修復

```python
# ❌ 錯誤：分母排除 skipped
done_nonzero = self.done - self.skipped - self.errors

# ✅ 正確：分母包含 skipped（與 total 基準一致）
done_nonzero = self.done - self.errors
```

---

## #10 — `run.py` `_DEFAULT_MODEL` 未傳入 `run_agent()`

**時間**：2026-06-02，測試時發現  
**發生位置**：`run.py::run_problem()` → `run_agent()` 呼叫

### 問題描述

`_DEFAULT_MODEL` 傳給了 `RunObserver`（只用於 `show_summary()` 的獨立 API call），但 `run_agent()` 呼叫本身沒有傳入 `model` 參數，導致 `run_agent()` 一直使用 `agent.py` 函式定義的 default 值，修改 `run.py` 的 `_DEFAULT_MODEL` 無效。

### 修復

```python
# run.py::run_problem()
result = run_agent(
    ...
    model=_DEFAULT_MODEL,   # ← 補上這一行
    ...
)
```

---

## #11 — `no_error_details` 模式下 `show_summary()` 仍顯示錯誤細節

**時間**：2026-06-02，使用者驗證時發現  
**發生位置**：`run.py::RunObserver.on_tool_result()` → `_summary_log`

### 問題描述

`on_tool_result("compile_and_test", result, ...)` 收到的是完整 `result`（含 `error_type`、`mismatch_count`），並將其記入 `_summary_log`。使用者按 `s` 後，`show_summary()` 把完整 log 送給獨立 Gemini call，生成的總結中含有 mismatch 數量等錯誤細節，與 `binary_feedback=True` 的隱藏設計不一致。

### 修復

`RunObserver.__init__()` 加入 `binary_feedback: bool = False`；`on_tool_result` 在 `binary_feedback=True` 時只記 `"[attempt N] compile_and_test → PASS/FAIL"`，不記 error_type / mismatch / error_log。`on_checkpoint` 也在此模式下只顯示 `❌ FAIL（no_error_details 模式）`，並從選單移除 `v` 選項。

---

## #12 — Docker `--env-file` 不支援 inline comment，導致 401 認證失敗

**時間**：2026-06-02，Docker 執行時發現  
**發生位置**：`.env` 檔案 inline comment + `docker run --env-file .env`

### 問題描述

在 WSL 用 `uv run run.py` 執行成功，但用 Docker `docker run --env-file .env ...` 執行時持續出現 401 UNAUTHENTICATED 錯誤：

```
google.genai.errors.ClientError: 401 UNAUTHENTICATED
{'error': {'code': 401, 'reason': 'ACCESS_TOKEN_TYPE_UNSUPPORTED'}}
```

`.env` 檔案原始內容：

```env
GEMINI_API_KEY=<API KEY> # 個人帳號
```

### 根本原因

**python-dotenv vs Docker `--env-file` 的 inline comment 處理不同**：

| 工具                | inline comment 支援 | 行為                                          |
| ------------------- | ------------------- | --------------------------------------------- |
| `python-dotenv`     | ✅ 支援             | 把 `# 個人帳號` 當 comment 丟棄，API key 乾淨 |
| Docker `--env-file` | ❌ 不支援           | 把 `  # 個人帳號` 當作值的一部分傳入          |

Docker 讀到的實際值：`<API_KEY>  # 個人帳號`

中文字符「個人帳號」（UTF-8：3 bytes × 4 字 = 12 bytes）被 Gemini API 當作 token 值的一部分，API 無法識別這個格式，誤判為使用 OAuth2 token，返回 `ACCESS_TOKEN_TYPE_UNSUPPORTED`。

**這也是之前 UnicodeEncodeError at position 42-45 和 57-60 的根本原因**——那正好是中文字符的 UTF-8 byte 範圍。

### 修復

移除 `.env` 的 inline comment，改用獨立行 comment：
修改後，無論 `python-dotenv` 或 Docker `--env-file` 都能正確解析，行為一致。

### 相關改動

由於誤診根本原因，先前加入了多個不必要的 workaround（都在 2026-06-02 修正移除）：

1. **Dockerfile**：曾改為 Ubuntu 22.04 + Python 3.11，改回 Ubuntu 24.04 + 預設 Python 3
2. **run.py** / **agent/agent.py**：曾加入 httpx encoding monkey patch，移除
3. **Dockerfile ENV**：曾加入 `PYTHONIOENCODING=utf-8` 等，移除
4. **requirements.txt**：把 `google-genai>=0.4.0` 改為 `google-genai==2.6.0`，保留（固定版本是好習慣）

### 驗證

```powershell
# 確認 Docker 讀到乾淨的 API key
docker run --env-file .env rl-agent python3 -c "import os; key = os.getenv('GEMINI_API_KEY'); print(f'Length: {len(key)}, Ends: {repr(key[-20:])}')"
# 期望輸出：Length: 53, Ends: '...-7A'（沒有 # 或中文字符）

# 執行測試
docker run -it --env-file .env -v "<本專案路徑>\outputs:/app/outputs" rl-agent
# 輸入 1，應成功通過 Prob001_zero
```

---

## 快速參考：google.genai tools 正確寫法

```python
from google import genai
from google.genai import types

tool = types.Tool(
    function_declarations=[
        types.FunctionDeclaration(
            name="function_name",
            description="說明",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "param1": types.Schema(type=types.Type.STRING, description="..."),
                    "param2": types.Schema(type=types.Type.INTEGER, description="..."),
                },
                required=["param1"],
            ),
        )
    ]
)

client = genai.Client(api_key="...")
chat = client.chats.create(
    model="gemini-3.1-flash-lite",
    config=types.GenerateContentConfig(
        system_instruction="...",
        tools=[tool],
    ),
)
```
