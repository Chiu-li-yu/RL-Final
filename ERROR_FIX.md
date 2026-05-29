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

| 嘗試 | Gemini 的猜測 | 實際效果 |
|------|--------------|---------|
| 1 | 原始寫法（無修改） | 錯誤相同 |
| 2 | 為 integer literal 加位元寬 `3'd0`, `16'd0` | 錯誤相同 |
| 3 | 為 enum 成員加顯式數值 `S_IDLE = 3'd0` | 錯誤相同 |

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

| 情境 | `get_interface` 可用？ | 說明 |
|------|----------------------|------|
| VerilogEval benchmark | ✅ 可用 | ref.sv 存在 |
| 真實 RTL 設計 | ❌ 不可用 | 沒有 ref.sv，介面要從規格設計 |

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
