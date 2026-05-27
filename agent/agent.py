"""
Verilog Coding Agent — Gemini multi-turn chat with function calling.

MDP 框架對應：
  State  = (problem_description, current_code, error_type, error_log, attempt_number)
  Action = Gemini 自行決定：生成/修正程式碼 → 呼叫 compile_and_test 或 decompose_spec
  Reward = +1 passed，0 failed
  Policy = Gemini（In-Context RL，不更新參數）
  Episode = 單一題目，最多 max_attempts 次 compile_and_test 呼叫

Module responsibilities:
  tools.py    — iverilog / vvp subprocess 呼叫
  dataset.py  — 檔案 I/O（題目讀取、輸出儲存）
  prompts.py  — system prompt 文字
  agent.py    — Gemini 對話迴圈 + function dispatch（本檔案）
"""

import os
import time
import random
import threading
from dataclasses import dataclass, field
from typing import Callable

from dotenv import load_dotenv
from google import genai
from google.genai import types
from google.api_core.exceptions import ResourceExhausted, ServiceUnavailable, DeadlineExceeded

from agent.tools import compile_and_test
from agent.prompts import get_system_prompt

load_dotenv()


# ── 全域速率限制器（可選，由 evaluate.py 啟用；run.py 不啟用）─────────────────

class _RateLimiter:
    """
    跨執行緒的全域 API 呼叫限速器（leaky bucket）。

    確保相鄰兩次 Gemini API 呼叫之間的最短間隔為 60/rpm 秒。
    在持有 lock 的情況下 sleep，因此多個 worker 的請求會排隊，
    不會同時打出超過限速的流量。
    """
    def __init__(self, rpm: int):
        self._interval = 60.0 / rpm   # 最短間隔（秒）
        self._lock     = threading.Lock()
        self._last     = 0.0          # 上次呼叫的 monotonic 時間

    def wait(self):
        with self._lock:
            elapsed = time.monotonic() - self._last
            gap = self._interval - elapsed
            if gap > 0:
                time.sleep(gap)
            self._last = time.monotonic()


_rate_limiter: _RateLimiter | None = None


def configure_rate_limit(rpm: int) -> None:
    """
    設定全域 API 呼叫速率上限。

    evaluate.py 在 run_batch() 開始時呼叫；run.py（互動模式）不呼叫。
    設為 0 或不呼叫表示不限速。

    Args:
        rpm: 每分鐘最多呼叫次數（例如 15）
    """
    global _rate_limiter
    _rate_limiter = _RateLimiter(rpm) if rpm > 0 else None


# ── Episode：單題執行狀態的單一持有者 ────────────────────────────────────────
@dataclass
class Episode:
    """
    一道題目從第一次嘗試到結束的執行狀態。

    把 attempts / final_code / last_result 集中在這裡，讓 run_agent() 的迴圈
    只需讀寫 ep.xxx，不需要在函式頂部散佈多個局部變數。
    """
    problem_id: str
    attempts:   int  = 0
    final_code: str  = ""
    last_result: dict = field(default_factory=lambda: {
        "passed":         False,
        "error_type":     "simulation_error",
        "error_log":      "未執行任何測試",
        "mismatch_count": 0,
    })

    def to_result(self) -> dict:
        """轉換為 run_agent() 的回傳格式。"""
        return {
            "problem_id": self.problem_id,
            "passed":     self.last_result["passed"],
            "attempts":   self.attempts,
            "final_code": self.final_code,
            "error_type": self.last_result["error_type"],
            "error_log":  self.last_result["error_log"],
        }


# ── Tool schemas（使用 types.Tool / FunctionDeclaration / Schema 正式格式）──
# GenerateContentConfig.tools 是 pydantic 嚴格型別，不接受 flat dict；
# 必須用 types.Tool(function_declarations=[types.FunctionDeclaration(...)]) 包裝。
_TOOLS = types.Tool(
    function_declarations=[
        types.FunctionDeclaration(
            name="compile_and_test",
            description=(
                "編譯並模擬 Verilog 程式碼。"
                "完成 TopModule 實作後，必須立刻呼叫此工具驗證。"
                "回傳 passed（bool）、error_type、error_log、mismatch_count。"
            ),
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "verilog_code": types.Schema(
                        type=types.Type.STRING,
                        description="完整的 TopModule Verilog 程式碼（從 module TopModule 到 endmodule）",
                    ),
                },
                required=["verilog_code"],
            ),
        ),
        types.FunctionDeclaration(
            name="decompose_spec",
            description=(
                "將題目規格分解成 3-5 個具體子目標清單。"
                "只在邏輯錯誤（simulation_error）多次修改仍無效時才呼叫。"
            ),
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "problem_description": types.Schema(
                        type=types.Type.STRING,
                        description="Verilog 題目的完整敘述",
                    ),
                },
                required=["problem_description"],
            ),
        ),
    ]
)

_BASE_DIR = __import__("pathlib").Path(__file__).parent.parent
_DATASET_DIRS = {
    "code-complete-iccad2023": _BASE_DIR / "verilog-eval" / "dataset_code-complete-iccad2023",
    "spec-to-rtl":             _BASE_DIR / "verilog-eval" / "dataset_spec-to-rtl",
}


# ── 私有工具函式 ──────────────────────────────────────────────────────────────

_RETRYABLE = (ResourceExhausted, ServiceUnavailable, DeadlineExceeded)


def _with_retry(fn, *args, max_retries: int = 5, **kwargs):
    """
    以指數退避重試一個 Gemini API 呼叫。

    處理的例外：
      ResourceExhausted  (429) — 超過 RPM / TPM 配額
      ServiceUnavailable (503) — Gemini 服務暫時不可用
      DeadlineExceeded   (504) — 請求逾時

    退避策略：首次等待 ~4s，之後每次翻倍，最長 60s，最多重試 max_retries 次。
    前兩次等待加入少量隨機抖動（jitter），避免多個 worker 同時重試時形成驚群。

    若有設定全域速率限制器（configure_rate_limit()），在每次呼叫前先等待。
    """
    for attempt in range(max_retries):
        try:
            if _rate_limiter:
                _rate_limiter.wait()   # ← 全域限速：確保不超過設定的 RPM
            return fn(*args, **kwargs)
        except _RETRYABLE as e:
            if attempt == max_retries - 1:
                raise  # 已達上限，讓例外往上傳
            wait = min(4 * (2 ** attempt) + random.uniform(0, 2), 60)
            print(f"[retry] {type(e).__name__} — {wait:.1f}s 後重試 "
                  f"({attempt + 1}/{max_retries - 1})…", flush=True)
            time.sleep(wait)


def _safe_text(response) -> str:
    """安全取得 response 的文字部分（function call 時可能為空）。"""
    try:
        return response.text or ""
    except Exception:
        return ""


def _decompose_spec(problem_description: str, model: str) -> str:
    """
    用 Gemini 將題目分解為 3-5 個子目標（單次呼叫，非對話）。

    從 tools.py 移到這裡，因為它是 LLM 呼叫，不是 subprocess 工具。
    與 compile_and_test 放在同一模組，是因為它由同一個 agent 對話迴圈調用。
    """
    client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
    response = _with_retry(
        client.models.generate_content,
        model=model,
        contents=(
            "請將以下 Verilog 題目分解成 3-5 個具體、可執行的子目標，"
            "每個子目標一行，用數字編號：\n\n"
            f"{problem_description}"
        ),
    )
    return response.text


def _build_initial_message(problem_id: str, problem_description: str, task: str) -> str:
    """組裝第一條 user 訊息。"""
    if task == "code-complete-iccad2023":
        ifc_path = _DATASET_DIRS[task] / f"{problem_id}_ifc.txt"
        ifc = ifc_path.read_text(encoding="utf-8").strip()
        return (
            f"請補全以下 Verilog module 的內部邏輯：\n\n"
            f"```verilog\n{ifc}\n```\n\n"
            f"題目說明：\n{problem_description}"
        )
    else:  # spec-to-rtl
        return (
            f"請根據以下規格，從零設計並實作完整的 Verilog module：\n\n"
            f"{problem_description}"
        )


# ── 主要公開介面 ──────────────────────────────────────────────────────────────

def run_agent(
    problem_id: str,
    problem_description: str,
    task: str,
    max_attempts: int = 3,
    model: str = "gemini-3.1-flash-lite",
    verbose: bool = False,
    # ── 顯示 / 互動 callbacks（全部可選，None 表示不使用）────────────────
    on_thinking:    Callable[[str], None]            | None = None,
    # fn(text)               Gemini 的思考文字
    on_tool_call:   Callable[[str, dict, int], None] | None = None,
    # fn(name, args, attempt) 工具即將被呼叫時
    on_tool_result: Callable[[str, dict, int], None] | None = None,
    # fn(name, result, attempt) 工具執行完畢後
    on_checkpoint:  Callable[[int, dict, str], bool] | None = None,
    # fn(attempt, result, code) -> bool
    #   在每次 compile_and_test 後呼叫；回傳 False 表示使用者要求中止
) -> dict:
    """
    對單一題目執行 Verilog Agent。

    Args:
        problem_id:          題目 ID，例如 "Prob001_zero"
        problem_description: 題目自然語言描述
        task:                "code-complete-iccad2023" 或 "spec-to-rtl"
        max_attempts:        最多允許幾次 compile_and_test 呼叫
        model:               Gemini model name
        verbose:             True 時印出簡易進度（與 callbacks 可並用）
        on_thinking:         收到 Gemini 文字回應時呼叫
        on_tool_call:        工具即將執行時呼叫
        on_tool_result:      工具執行完畢後呼叫
        on_checkpoint:       compile_and_test 完成後呼叫，回傳 False 可中止 agent

    Returns:
        {
            "problem_id":    str,
            "passed":        bool,
            "attempts":      int,   # 實際呼叫 compile_and_test 的次數
            "final_code":    str,   # 最後一次送去 compile 的程式碼
            "error_type":    str,   # 最後一次的 error_type
            "error_log":     str,   # 最後一次的 error_log
        }
    """
    client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
    system_prompt = get_system_prompt(task)

    # ── 建立 chat session ────────────────────────────────────────────────────
    config = types.GenerateContentConfig(
        system_instruction=system_prompt,
        tools=[_TOOLS],
    )
    chat = client.chats.create(model=model, config=config)

    # ── Episode：本題執行狀態 ────────────────────────────────────────────────
    ep = Episode(problem_id=problem_id)

    # ── 第一條訊息 ───────────────────────────────────────────────────────────
    user_msg = _build_initial_message(problem_id, problem_description, task)
    response = _with_retry(chat.send_message, user_msg)

    # ── 主迴圈：最多 max_attempts 次 compile_and_test ────────────────────────
    while ep.attempts < max_attempts:

        # ── Gemini 的思考文字（工具呼叫前可能附有說明）──────────────────────
        thinking = _safe_text(response)
        if thinking.strip():
            if on_thinking:
                on_thinking(thinking.strip())
            elif verbose:
                print(f"[Gemini] {thinking.strip()[:200]}")

        # ── 取出所有 function calls ──────────────────────────────────────────
        fc_list = response.function_calls
        if not fc_list:
            # Gemini 回覆純文字，沒有呼叫工具 → 提示它應該呼叫工具
            if verbose:
                print("[agent] 未偵測到工具呼叫，提醒呼叫 compile_and_test ...")
            response = _with_retry(
                chat.send_message,
                "請完成 Verilog 程式碼後，呼叫 compile_and_test 工具驗證。",
            )
            continue

        # ── 逐一處理 function calls ──────────────────────────────────────────
        tool_results = []
        should_stop = False

        for fc in fc_list:
            if fc.name == "compile_and_test":
                verilog_code = fc.args["verilog_code"]
                ep.final_code = verilog_code
                ep.attempts += 1

                # 呼叫前通知
                if on_tool_call:
                    on_tool_call("compile_and_test", {"verilog_code": verilog_code}, ep.attempts)
                elif verbose:
                    print(f"[agent] compile_and_test (attempt {ep.attempts}/{max_attempts})")

                # 執行工具
                result = compile_and_test(verilog_code, problem_id, task)
                ep.last_result = result

                # 執行後通知
                if on_tool_result:
                    on_tool_result("compile_and_test", result, ep.attempts)
                elif verbose:
                    status = "✅ PASS" if result["passed"] else f"❌ {result['error_type']}"
                    print(f"[agent]   → {status}  (attempt {ep.attempts}/{max_attempts})")

                if result["passed"]:
                    should_stop = True

                # 人工介入點
                if on_checkpoint:
                    if not on_checkpoint(ep.attempts, result, verilog_code):
                        should_stop = True

                tool_results.append(
                    types.Part.from_function_response(
                        name="compile_and_test",
                        response=result,
                    )
                )

            elif fc.name == "decompose_spec":
                problem_desc = fc.args["problem_description"]

                if on_tool_call:
                    on_tool_call("decompose_spec", {"problem_description": problem_desc}, ep.attempts)
                elif verbose:
                    print("[agent] decompose_spec ...")

                decomposed = _decompose_spec(problem_desc, model)

                if on_tool_result:
                    on_tool_result("decompose_spec", {"sub_goals": decomposed}, ep.attempts)
                elif verbose:
                    print("[agent]   → 子目標清單取得完成")

                tool_results.append(
                    types.Part.from_function_response(
                        name="decompose_spec",
                        response={"sub_goals": decomposed},
                    )
                )

            else:
                tool_results.append(
                    types.Part.from_function_response(
                        name=fc.name,
                        response={"error": f"Unknown tool: {fc.name}"},
                    )
                )

        # ── 通過或使用者中止 → 停止 ──────────────────────────────────────────
        if should_stop:
            break

        # ── 達到上限 → 停止 ──────────────────────────────────────────────────
        if ep.attempts >= max_attempts:
            break

        # ── 把 tool results 送回 Gemini，繼續對話 ────────────────────────────
        response = _with_retry(chat.send_message, tool_results)

    return ep.to_result()