"""
Verilog Coding Agent — Gemini multi-turn chat with function calling.

MDP 框架對應：
  State  = (problem_description, current_code, error_type, error_log, attempt_number)
  Action = Gemini 自行決定：生成/修正程式碼 → 呼叫 compile_and_test 或 decompose_spec
  Reward = +1 passed，0 failed
  Policy = Gemini（In-Context RL，不更新參數）
  Episode = 單一題目，最多 max_attempts 次 compile_and_test 呼叫

Module responsibilities:
  tools.py    — iverilog / vvp subprocess 呼叫（純 I/O，不知道 task 名稱）
  dataset.py  — 檔案 I/O（題目讀取、輸出儲存）
  prompts.py  — system prompt 文字 + DEBUG_HINTS
  task.py     — Task 配置（dataset_dir / prompt_dir / system_prompt 的單一來源）
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
from agent.prompts import DEBUG_HINTS
from agent.task import Task

load_dotenv()


# ── 速率限制器（可選，由呼叫方建立後傳入 run_agent）─────────────────────────

class RateLimiter:
    """
    跨執行緒的 API 呼叫限速器（leaky bucket）。

    確保相鄰兩次 Gemini API 呼叫之間的最短間隔為 60/rpm 秒。
    在持有 lock 的情況下 sleep，多個 worker 的請求會排隊。

    建立方式：
        limiter = RateLimiter(rpm=14)
        run_agent(..., rate_limiter=limiter)
    """
    def __init__(self, rpm: int):
        self._interval = 60.0 / rpm
        self._lock     = threading.Lock()
        self._last     = 0.0

    def wait(self):
        with self._lock:
            elapsed = time.monotonic() - self._last
            gap = self._interval - elapsed
            if gap > 0:
                time.sleep(gap)
            self._last = time.monotonic()


# ── Episode：單題執行狀態的單一持有者 ────────────────────────────────────────

@dataclass
class Episode:
    """
    一道題目從第一次嘗試到結束的執行狀態。
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
        return {
            "problem_id": self.problem_id,
            "passed":     self.last_result["passed"],
            "attempts":   self.attempts,
            "final_code": self.final_code,
            "error_type": self.last_result["error_type"],
            "error_log":  self.last_result["error_log"],
        }


# ── Tool schemas ──────────────────────────────────────────────────────────────

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


# ── 私有工具函式 ──────────────────────────────────────────────────────────────

_RETRYABLE = (ResourceExhausted, ServiceUnavailable, DeadlineExceeded)


def _with_retry(
    fn,
    *args,
    rate_limiter: RateLimiter | None = None,
    max_retries: int = 5,
    **kwargs,
):
    """
    以指數退避重試一個 Gemini API 呼叫。

    rate_limiter: 由呼叫方（run_agent）傳入；None 表示不限速。
    """
    for attempt in range(max_retries):
        try:
            if rate_limiter:
                rate_limiter.wait()
            return fn(*args, **kwargs)
        except _RETRYABLE as e:
            if attempt == max_retries - 1:
                raise
            wait = min(4 * (2 ** attempt) + random.uniform(0, 2), 60)
            print(f"[retry] {type(e).__name__} — {wait:.1f}s 後重試 "
                  f"({attempt + 1}/{max_retries - 1})…", flush=True)
            time.sleep(wait)


def _safe_text(response) -> str:
    """安全取得 response 的純文字部分，忽略 function_call parts。"""
    try:
        parts = response.candidates[0].content.parts
        texts = [p.text for p in parts if getattr(p, "text", None)]
        return "\n".join(texts)
    except Exception:
        return ""


def _decompose_spec(
    problem_description: str,
    model: str,
    rate_limiter: RateLimiter | None = None,
) -> str:
    """用 Gemini 將題目分解為 3-5 個子目標（單次呼叫，非對話）。"""
    client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
    response = _with_retry(
        client.models.generate_content,
        model=model,
        contents=(
            "請將以下 Verilog 題目分解成 3-5 個具體、可執行的子目標，"
            "每個子目標一行，用數字編號：\n\n"
            f"{problem_description}"
        ),
        rate_limiter=rate_limiter,
    )
    return response.text


def _build_initial_message(problem_id: str, problem_description: str, task: Task) -> str:
    """組裝第一條 user 訊息。"""
    if task.name == "code-complete-iccad2023":
        ifc_path = task.dataset_dir / f"{problem_id}_ifc.txt"
        ifc = ifc_path.read_text(encoding="utf-8").strip()
        return (
            f"請補全以下 Verilog module 的內部邏輯：\n\n"
            f"```verilog\n{ifc}\n```\n\n"
            f"題目說明：\n{problem_description}"
        )
    else:
        return (
            f"請根據以下規格，從零設計並實作完整的 Verilog module：\n\n"
            f"{problem_description}"
        )


# ── 主要公開介面 ──────────────────────────────────────────────────────────────

def run_agent(
    problem_id: str,
    problem_description: str,
    task: Task,
    max_attempts: int = 3,
    model: str = "gemini-3.1-flash-lite",
    verbose: bool = False,
    rate_limiter: RateLimiter | None = None,
    # ── 顯示 / 互動 callbacks（全部可選）────────────────────────────────────
    on_thinking:    Callable[[str], None]            | None = None,
    on_tool_call:   Callable[[str, dict, int], None] | None = None,
    on_tool_result: Callable[[str, dict, int], None] | None = None,
    on_save:        Callable[[int, str], None]       | None = None,
    # fn(attempt, code)   compile_and_test 完成後儲存程式碼（不論通過與否）
    on_checkpoint:  Callable[[int, dict, str], bool] | None = None,
    # fn(attempt, result, code) -> bool   回傳 False 中止 agent
) -> dict:
    """
    對單一題目執行 Verilog Agent。

    Args:
        problem_id:          題目 ID，例如 "Prob001_zero"
        problem_description: 題目自然語言描述
        task:                Task 物件（含 dataset_dir、system_prompt）
        max_attempts:        最多允許幾次 compile_and_test 呼叫
        model:               Gemini model name
        verbose:             True 時印出簡易進度
        rate_limiter:        RateLimiter 實例；None 表示不限速
        on_thinking:         收到 Gemini 文字回應時呼叫
        on_tool_call:        工具即將執行時呼叫
        on_tool_result:      工具執行完畢後呼叫
        on_save:             compile_and_test 完成後呼叫（儲存用，無回傳值）
        on_checkpoint:       compile_and_test 完成後呼叫（控制流用），回傳 False 中止

    Returns:
        {"problem_id", "passed", "attempts", "final_code", "error_type", "error_log"}
    """
    # 建立 retry 包裝，捕獲 rate_limiter
    def retry(fn, *args, **kwargs):
        return _with_retry(fn, *args, rate_limiter=rate_limiter, **kwargs)

    client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

    config = types.GenerateContentConfig(
        system_instruction=task.system_prompt,
        tools=[_TOOLS],
    )
    chat = client.chats.create(model=model, config=config)

    ep = Episode(problem_id=problem_id)
    user_msg = _build_initial_message(problem_id, problem_description, task)
    response = retry(chat.send_message, user_msg)

    while ep.attempts < max_attempts:

        thinking = _safe_text(response)
        if thinking.strip():
            if on_thinking:
                on_thinking(thinking.strip())
            elif verbose:
                print(f"[Gemini] {thinking.strip()[:200]}")

        fc_list = response.function_calls
        if not fc_list:
            if verbose:
                print("[agent] 未偵測到工具呼叫，提醒呼叫 compile_and_test ...")
            response = retry(
                chat.send_message,
                "請完成 Verilog 程式碼後，呼叫 compile_and_test 工具驗證。",
            )
            continue

        tool_results = []
        should_stop  = False

        for fc in fc_list:
            if fc.name == "compile_and_test":
                verilog_code  = fc.args["verilog_code"]
                ep.final_code = verilog_code
                ep.attempts  += 1

                if on_tool_call:
                    on_tool_call("compile_and_test", {"verilog_code": verilog_code}, ep.attempts)
                elif verbose:
                    print(f"[agent] compile_and_test (attempt {ep.attempts}/{max_attempts})")

                # 執行工具（bare result，不含 debug_hints）
                result = compile_and_test(verilog_code, problem_id, task.dataset_dir)

                # dispatch handler 附加 debug_hints（候選 2：移出 tools.py）
                error_code = result.get("error_type", "")
                if error_code in DEBUG_HINTS:
                    result = dict(result)
                    result["debug_hints"] = DEBUG_HINTS[error_code]

                ep.last_result = result

                if on_tool_result:
                    on_tool_result("compile_and_test", result, ep.attempts)
                elif verbose:
                    status = "✅ PASS" if result["passed"] else f"❌ {result['error_type']}"
                    print(f"[agent]   → {status}  (attempt {ep.attempts}/{max_attempts})")

                if result["passed"]:
                    should_stop = True

                # 儲存 callback（無回傳值，不控制流程）
                if on_save:
                    on_save(ep.attempts, verilog_code)

                # 控制流 callback
                if on_checkpoint:
                    if not on_checkpoint(ep.attempts, result, verilog_code):
                        should_stop = True

                tool_results.append(types.Part.from_function_response(
                    name="compile_and_test", response=result,
                ))

            elif fc.name == "decompose_spec":
                problem_desc = fc.args["problem_description"]

                if on_tool_call:
                    on_tool_call("decompose_spec", {"problem_description": problem_desc}, ep.attempts)
                elif verbose:
                    print("[agent] decompose_spec ...")

                decomposed = _decompose_spec(problem_desc, model, rate_limiter=rate_limiter)

                if on_tool_result:
                    on_tool_result("decompose_spec", {"sub_goals": decomposed}, ep.attempts)
                elif verbose:
                    print("[agent]   → 子目標清單取得完成")

                tool_results.append(types.Part.from_function_response(
                    name="decompose_spec", response={"sub_goals": decomposed},
                ))

            else:
                tool_results.append(types.Part.from_function_response(
                    name=fc.name,
                    response={"error": f"Unknown tool: {fc.name}"},
                ))

        if should_stop:
            break

        if ep.attempts >= max_attempts:
            break

        response = retry(chat.send_message, tool_results)

    return ep.to_result()
