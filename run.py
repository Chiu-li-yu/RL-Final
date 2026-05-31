#!/usr/bin/env python3
"""
互動式 Verilog Agent CLI — 簡化版 Claude Code 風格

這個檔案只負責「顯示與互動」，不碰檔案系統或資料集路徑：
  - 顯示 Gemini 的思考過程與工具呼叫（callbacks）
  - 每次 compile_and_test 後提供人工介入點
  - 儲存邏輯委派給 agent.dataset

Callback 分工：
  on_save(attempt, code)               — 儲存程式碼（純 I/O，無回傳值）
  on_checkpoint(attempt, result, code) — 顯示結果 + 人工互動（回傳 bool 控制流程）

Usage:
    python run.py                                                # REPL 模式
    python run.py Prob001_zero                                   # 預設 spec-to-rtl / agent
    python run.py Prob001_zero code-complete-iccad2023           # 指定任務
    python run.py Prob001_zero spec-to-rtl no_debug_hints        # 指定實驗組

可用 experiment：agent / no_debug_hints / no_decompose / no_helper_tools / no_memory
"""

import sys
from dotenv import load_dotenv

load_dotenv()

import os
from google import genai

from agent.agent import run_agent
from agent.task import get_task, Task
from agent.dataset import load_problem, save_code, save_result, list_problems
from agent.experiments import ALL_EXPERIMENTS, get_experiment

_DEFAULT_MODEL = "gemma-4-31b-it" # "gemini-3.1-flash-lite" # gemma-4-31b-it


def _resolve_problem_id(token: str, task: Task) -> str | None:
    """
    將使用者輸入轉換為完整的 problem_id。
    - 純數字（1~3 位）：在題目清單中找開頭為 ProbXXX_ 的題目
    - 其他：原樣回傳（假設已是完整 ID）
    """
    if not token.isdigit():
        return token
    prefix = f"Prob{int(token):03d}_"
    for pid in list_problems(task):
        if pid.startswith(prefix):
            return pid
    return None

VALID_EXPS = tuple(ALL_EXPERIMENTS.keys())

# ── ANSI 色碼 ─────────────────────────────────────────────────────────────────
R     = "\033[0m"
BOLD  = "\033[1m"
CYAN  = "\033[36m"
YELLOW= "\033[33m"
GREEN = "\033[32m"
RED   = "\033[31m"
GRAY  = "\033[90m"

LINE  = "─" * 52
DLINE = "━" * 52


# ── 輸出工具函式 ──────────────────────────────────────────────────────────────

def _print(text: str = ""):
    print(text, flush=True)

def header(text: str):
    _print(f"\n{DLINE}")
    _print(f"{BOLD}{text}{R}")
    _print(DLINE)

def section(text: str):
    _print(f"\n{LINE}")
    _print(text)
    _print(LINE)


# ── RunObserver：互動模式的 callback adapter ─────────────────────────────────

class RunObserver:
    """
    Holds per-problem display context for all run_agent() callbacks.
    Groups what were previously 5 scattered functions (on_thinking, on_tool_call,
    on_tool_result, _make_on_save, _make_checkpoint) into one cohesive object,
    making run_problem() a single run_agent() call with obs.method references.
    """

    def __init__(self, problem_id: str, task: Task, experiment: str,
                 model: str = _DEFAULT_MODEL, binary_feedback: bool = False):
        self._problem_id      = problem_id
        self._task            = task
        self._experiment      = experiment
        self._model           = model
        self._binary_feedback = binary_feedback
        # 精簡的過程 log，供 show_summary() 使用
        self._summary_log: list[str] = []

    # ── Display callbacks ─────────────────────────────────────────────────────

    def on_thinking(self, text: str) -> None:
        _print(f"\n{GRAY}{text}{R}")

    def on_tool_call(self, name: str, args: dict, attempt: int) -> None:
        if name == "compile_and_test":
            code  = args.get("verilog_code", "")
            lines = code.splitlines()
            preview = "\n".join(lines[:25])
            if len(lines) > 25:
                preview += f"\n{GRAY}  … ({len(lines) - 25} more lines){R}"
            _print(f"\n{LINE}")
            _print(f"{YELLOW}{BOLD}🔧  compile_and_test{R}  (attempt {attempt})")
            _print(LINE)
            _print(preview)
            _print(LINE)
        elif name == "synthesize":
            _print(f"\n{YELLOW}⚙️   synthesize{R}  (attempt {attempt})")
        elif name == "decompose_spec":
            desc = args.get("problem_description", "")
            _print(f"\n{YELLOW}🔍  decompose_spec{R}")
            _print(f"{GRAY}{desc[:200]}…{R}")
        elif name == "get_debug_hints":
            error_type = args.get("error_type", "?")
            _print(f"\n{YELLOW}💡  get_debug_hints{R}  error_type={error_type!r}")

    def on_tool_result(self, name: str, result: dict, attempt: int) -> None:
        if name == "compile_and_test":
            # 累積精簡過程 log（供總結使用）
            # binary_feedback 模式下只記 pass/fail，不記錯誤細節
            if self._binary_feedback:
                status = "PASS" if result.get("passed") else "FAIL"
                self._summary_log.append(f"[attempt {attempt}] compile_and_test → {status}")
            else:
                etype = result.get("error_type", "?")
                mc    = result.get("mismatch_count", 0)
                entry = f"[attempt {attempt}] compile_and_test → {etype}"
                if mc > 0:
                    entry += f"（{mc} mismatches）"
                if result.get("error_log"):
                    entry += f"\n  錯誤：{result['error_log'].splitlines()[0][:120]}"
                self._summary_log.append(entry)
        elif name == "synthesize":
            etype = result.get("error_type", "?")
            self._summary_log.append(f"[attempt {attempt}] synthesize → {etype}")
            if result["passed"]:
                _print(f"{GREEN}{BOLD}✅  Synthesis PASS{R}")
            else:
                _print(f"{RED}❌  Ys  synthesis error{R}")
                for line in result.get("error_log", "").splitlines()[:6]:
                    _print(f"   {GRAY}{line}{R}")
        elif name == "decompose_spec":
            self._summary_log.append(f"[attempt {attempt}] decompose_spec 呼叫")
            _print(f"{GRAY}{result.get('sub_goals', '')[:400]}{R}")
        elif name == "get_debug_hints":
            error_type = result.get("error_type", "?")
            self._summary_log.append(f"[attempt {attempt}] get_debug_hints({error_type!r})")
            hints = result.get("hints", "")
            if hints:
                _print(f"{CYAN}── hints ──{R}")
                for line in hints.splitlines():
                    _print(f"   {GRAY}{line}{R}")
            else:
                _print(f"{GRAY}（無對應提示）{R}")

    # ── I/O callback ──────────────────────────────────────────────────────────

    def on_save(self, attempt: int, code: str) -> None:
        out_file = save_code(
            self._problem_id, attempt, code,
            task=self._task, experiment=self._experiment,
        )
        _print(f"{GRAY}💾  saved → {out_file}{R}")

    # ── Summary ───────────────────────────────────────────────────────────────

    def show_summary(self, is_success: bool) -> None:
        """呼叫 Gemini 生成過程總結並顯示於終端。"""
        if not self._summary_log:
            _print(f"{GRAY}（目前尚無嘗試紀錄）{R}")
            return

        log_text = "\n".join(self._summary_log)

        if is_success:
            prompt = (
                f"以下是一道 Verilog 題目（{self._problem_id}）的解題過程紀錄：\n\n"
                f"{log_text}\n\n"
                "請用繁體中文，簡潔地總結：\n"
                "1. 一開始遇到什麼問題\n"
                "2. 中途做了哪些修改\n"
                "3. 最終是什麼改動讓題目通過\n"
                "請用 3-5 句話回答，不需要程式碼。"
            )
        else:
            prompt = (
                f"以下是一道 Verilog 題目（{self._problem_id}）目前的解題過程紀錄：\n\n"
                f"{log_text}\n\n"
                "請用繁體中文，簡潔地總結目前遇到的問題，以及已嘗試過的修改方向。"
                "請用 2-4 句話回答，不需要程式碼。"
            )

        _print(f"\n{CYAN}── 正在生成總結 …{R}")
        try:
            client   = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
            response = client.models.generate_content(
                model=self._model,
                contents=prompt,
            )
            _print(f"\n{CYAN}{BOLD}📝  過程總結{R}")
            _print(LINE)
            _print(response.text.strip())
            _print(LINE)
        except Exception as e:
            _print(f"{GRAY}（總結生成失敗：{e}）{R}")

    # ── Control-flow callback ─────────────────────────────────────────────────

    def on_checkpoint(self, attempt: int, result: dict, code: str) -> bool | str:
        if result["passed"]:
            _print(f"\n{GREEN}{BOLD}✅  simulation PASS — 呼叫 synthesize 驗證可合成性{R}")
            return True

        if self._binary_feedback:
            _print(f"\n{RED}❌  FAIL{R}  （no_error_details 模式：錯誤細節已隱藏）")
        else:
            etype  = result["error_type"]
            mc     = result.get("mismatch_count", 0)
            _print(f"\n{RED}❌  {etype}{R}" + (f"  (mismatches: {mc})" if mc > 0 else ""))

            if result.get("error_log"):
                err_lines = result["error_log"].splitlines()
                for line in err_lines[:6]:
                    _print(f"   {GRAY}{line}{R}")
                if len(err_lines) > 6:
                    _print(f"   {GRAY}  … ({len(err_lines) - 6} more lines, 輸入 v 查看全部){R}")

        _print(f"\n{DLINE}")
        menu = (
            f"{CYAN}繼續讓 Agent 嘗試？{R}（第 {attempt} 次） "
            f"[{BOLD}Enter{R} 繼續 / "
            f"{BOLD}a{R} 中止 / "
            + (f"" if self._binary_feedback else
               f"{BOLD}v{R} 完整 log / ")
            + f"{BOLD}c{R} 完整程式碼 / "
            f"{BOLD}h{R} 補充修改方向 / "
            f"{BOLD}s{R} 總結目前過程] > "
        )
        while True:
            try:
                ans = input(menu).strip().lower()
            except (EOFError, KeyboardInterrupt):
                _print()
                return False

            if ans == "a":
                _print(f"{GRAY}已中止。{R}")
                return False
            elif ans == "v":
                if self._binary_feedback:
                    _print(f"{GRAY}（no_error_details 模式：不顯示 error log）{R}")
                else:
                    _print(f"\n{GRAY}── Error Log ──{R}")
                    _print(result.get("error_log", "(無 error log)"))
            elif ans == "c":
                _print(f"\n{GRAY}── Generated Code ──{R}")
                _print(code)
            elif ans == "h":
                try:
                    hint = input("補充修改方向 > ").strip()
                except (EOFError, KeyboardInterrupt):
                    _print()
                    return False
                if hint:
                    _print(f"{GRAY}已注入：{hint}{R}")
                    return hint
            elif ans == "s":
                self.show_summary(is_success=False)
            else:
                return True


# ── 單題執行 ──────────────────────────────────────────────────────────────────

def run_problem(
    problem_id: str,
    task: Task,
    experiment: str = "agent",
    max_attempts: int = 999,
):
    try:
        exp = get_experiment(experiment)
    except ValueError as e:
        _print(f"{RED}{e}{R}")
        _print(f"可用：{', '.join(VALID_EXPS)}")
        return

    try:
        problem_desc = load_problem(problem_id, task)
    except FileNotFoundError:
        _print(f"{RED}找不到題目描述檔（problem_id={problem_id!r}, task={task.name!r}）{R}")
        _print("請確認 problem_id 拼法（例如 Prob001_zero）")
        return

    header(f"🎯  {problem_id}  [{task.name}]  [{experiment}]")
    _print(problem_desc[:600] + ("…" if len(problem_desc) > 600 else ""))
    _print(DLINE)

    obs = RunObserver(problem_id, task, experiment, model=_DEFAULT_MODEL,
                      binary_feedback=exp.binary_feedback)
    result = run_agent(
        problem_id=problem_id,
        problem_description=problem_desc,
        task=task,
        max_attempts=max_attempts,
        model=_DEFAULT_MODEL,
        verbose=False,
        enabled_tools=exp.enabled_tools,
        binary_feedback=exp.binary_feedback,
        on_thinking=obs.on_thinking,
        on_tool_call=obs.on_tool_call,
        on_tool_result=obs.on_tool_result,
        on_save=obs.on_save,
        on_checkpoint=obs.on_checkpoint,
    )

    save_result(problem_id, result, task=task, experiment=experiment)

    out_prefix = f"outputs/{experiment}/{task.name}/{problem_id}"
    _print(f"\n{DLINE}")
    sim_ok = result.get("sim_passed", result.get("passed", False))
    if result["passed"]:
        _print(f"{GREEN}{BOLD}🎉  完成！模擬✅ 合成✅  共 {result['attempts']} 次嘗試{R}")
        _print(f"📄  {out_prefix}/attempt_{result['attempts']}.sv")
        # 成功後自動生成總結（僅在超過 1 次嘗試時，1 次就過不需要總結）
        if result["attempts"] > 1:
            obs.show_summary(is_success=True)
    elif sim_ok:
        _print(f"{YELLOW}⚠️   模擬✅ 合成✗  共 {result['attempts']} 次嘗試{R}")
        _print(f"📄  {out_prefix}/attempt_{result['attempts']}.sv")
    else:
        _print(f"{RED}😞  未通過  共 {result['attempts']} 次嘗試{R}")
        if result["attempts"] > 0:
            _print(f"📄  {out_prefix}/attempt_{result['attempts']}.sv  （最後的程式碼）")
    _print(DLINE + "\n")


# ── REPL 主迴圈 ───────────────────────────────────────────────────────────────

def repl():
    header("🤖  Verilog Agent  Interactive Mode")
    _print("輸入 <problem_id> [task] [experiment] 開始")
    _print(f"  task       預設 spec-to-rtl  /  code-complete-iccad2023")
    _print(f"  experiment 預設 agent  /  {' / '.join(VALID_EXPS)}")
    _print("輸入 q 離開\n")

    while True:
        try:
            line = input(f"{CYAN}>> {R}").strip()
        except (EOFError, KeyboardInterrupt):
            _print("\n再見！")
            break

        if not line:
            continue
        if line.lower() in ("q", "exit", "quit"):
            _print("再見！")
            break

        parts      = line.split()
        token      = parts[0]
        task_name  = parts[1] if len(parts) > 1 else "spec-to-rtl"
        experiment = parts[2] if len(parts) > 2 else "agent"

        try:
            task = get_task(task_name)
        except ValueError as e:
            _print(f"{RED}{e}{R}")
            continue

        problem_id = _resolve_problem_id(token, task)
        if problem_id is None:
            _print(f"{RED}找不到題目編號 {token!r}（task={task_name}）{R}")
            continue

        run_problem(problem_id, task, experiment)


# ── Entry point ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    args = sys.argv[1:]

    if len(args) == 0:
        repl()
    elif len(args) <= 3:
        task_name  = args[1] if len(args) > 1 else "spec-to-rtl"
        experiment = args[2] if len(args) > 2 else "agent"
        try:
            task = get_task(task_name)
        except ValueError as e:
            print(e); sys.exit(1)
        problem_id = _resolve_problem_id(args[0], task)
        if problem_id is None:
            print(f"找不到題目編號 {args[0]!r}（task={task_name}）")
            sys.exit(1)
        run_problem(problem_id, task, experiment)
    else:
        print("Usage: python run.py [problem_id] [task] [experiment]")
        print(f"  experiment: {', '.join(VALID_EXPS)}")
        sys.exit(1)
