# 基於 Gemini 的 Verilog RTL 生成 Agent

**In-Context RL for Hardware Description Language Generation**

以 Gemini Function Calling 驅動的 Verilog RTL 自動生成 Agent，透過迭代編譯、模擬與合成驗證的回饋去修正程式碼，並以 VerilogEval 標準測試集（156 題）進行評估。

---

## 環境需求

| 項目           | 版本 / 說明                                                       |
| -------------- | ----------------------------------------------------------------- |
| Docker Desktop | 最新版（包含 Docker Engine）                                      |
| Gemini API Key | [Google AI Studio](https://aistudio.google.com/) 申請免費 API key |

---

## 安裝步驟

### 1. Clone 專案

```bash
git clone https://github.com/Chiu-li-yu/RL-Final.git
cd RL-Final
```

### 2. 確認 Docker Desktop 執行

確保 Docker Desktop 應用正在執行。

### 3. 建立 Docker 映像

```bash
docker build -t rl-agent .
```

### 4. 準備 VerilogEval 資料集

確認 `verilog-eval/` 目錄存在，並包含以下子目錄：

```
verilog-eval/
  dataset_spec-to-rtl/          # spec-to-rtl 任務（156 題）
  dataset_code-complete-iccad2023/  # code-complete 任務（156 題）
```

若尚未下載，請參考 [VerilogEval 官方 Repository](https://github.com/NVlabs/verilogeval)。

---

## 執行方式

**可用實驗組別：**

| 組別               | 說明                                |
| ------------------ | ----------------------------------- |
| `agent`            | 完整系統（預設）                    |
| `no_debug_hints`   | 移除 get_debug_hints 工具           |
| `no_decompose`     | 移除 decompose_spec 工具            |
| `no_helper_tools`  | 僅 compile_and_test + synthesize    |
| `no_memory`        | 5 次獨立 session，無跨輪記憶        |
| `no_error_details` | 只告知模型通過/失敗，不提供錯誤細節 |

### 互動式單題測試

```bash
# REPL 模式（依提示輸入題目編號）
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent

# 直接指定題目
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 run.py Prob001_zero

# 指定任務類型
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 run.py Prob001_zero code-complete-iccad2023

# 指定實驗組別
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 run.py Prob001_zero spec-to-rtl no_debug_hints
```

**互動式操作選項：**

每次 compile_and_test 失敗後，使用者可選擇：

- `Enter`：繼續讓 Agent 嘗試
- `a`：中止當前題目
- `v`：查看完整 error log
- `c`：查看完整程式碼
- `h`：補充修改方向（注入至 Agent 對話）
- `s`：請 Gemini 生成當前過程總結

### 批次實驗

```bash
# 基本用法
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 evaluate.py --exp agent --task spec-to-rtl

# 常用參數
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 evaluate.py \
    --exp agent \
    --task spec-to-rtl \
    --rpm 15 \
    --workers 1

# 只列出待執行題目（不呼叫 API）
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 evaluate.py --exp agent --task spec-to-rtl --dry-run

# 強制重跑所有題目（忽略既有 result.json）
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 evaluate.py --exp agent --task spec-to-rtl --no-resume
```

---

## 輸出結構

```
outputs/
  {實驗組別}/
    {任務名稱}/
      {problem_id}/
        attempt_1.sv    # 每次 compile_and_test 的程式碼
        attempt_2.sv
        result.json     # 最終結果（通過率、嘗試次數、錯誤序列）
        run.log         # 完整執行紀錄
```

`result.json` 範例：

```json
{
  "problem_id": "Prob001_zero",
  "passed": true,
  "sim_passed": true,
  "synth_passed": true,
  "attempts": 1,
  "sim_error_type": ".",
  "task": "spec-to-rtl",
  "experiment": "agent"
}
```

---

**說明：**
- `-v $(pwd)/outputs:/app/outputs` 將容器內的結果掛載到本機 `outputs/` 目錄
- `-e GEMINI_API_KEY=...` 傳入 API key（不寫入 `.env` 檔案）
- 容器內環境完全獨立，不受 NTFS / OneDrive 影響

---

## 實驗工具測試

```bash
# 執行工具層與模擬器的整合測試
docker run -it \
  -e GEMINI_API_KEY=你的_API_Key \
  -v $(pwd)/outputs:/app/outputs \
  rl-agent \
  python3 test_tools.py
```

---

## 主要依賴套件

```
google-genai    # Gemini API（新版官方 SDK）
python-dotenv   # .env 環境變數載入
```

---

## 組員

邱立宇、戴庭涵
