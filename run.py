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

from agent.agent import run_agent
from agent.task import get_task, Task
from agent.dataset import load_problem, save_code, save_result, list_problems


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

# 各實驗組對應的 enabled_tools 設定
_EXP_TOOLS: dict[str, frozenset[str] | None] = {
    "agent":           None,
    "no_debug_hints":  frozenset({"compile_and_test", "synthesize", "decompose_spec"}),
    "no_decompose":    frozenset({"compile_and_test", "synthesize", "get_debug_hints"}),
    "no_helper_tools": frozenset({"compile_and_test", "synthesize"}),
    "no_memory":       None,
}
VALID_EXPS = tuple(_EXP_TOOLS.keys())

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


# ── Callbacks（純顯示層，不碰 I/O）───────────────────────────────────────────

def _on_thinking(text: str):
    _print(f"\n{GRAY}{text}{R}")


def _on_tool_call(name: str, args: dict, attempt: int):
    if name == "compile_and_test":
        code = args.get("verilog_code", "")
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


def _on_tool_result(name: str, result: dict, _attempt: int):
    if name == "synthesize":
        if result["passed"]:
            _print(f"{GREEN}{BOLD}✅  Synthesis PASS{R}")
        else:
            _print(f"{RED}❌  Ys  synthesis error{R}")
            if result.get("error_log"):
                for line in result["error_log"].splitlines()[:6]:
                    _print(f"   {GRAY}{line}{R}")

    elif name == "decompose_spec":
        sub_goals = result.get("sub_goals", "")
        _print(f"{GRAY}{sub_goals[:400]}{R}")

    elif name == "get_debug_hints":
        hints = result.get("hints", "")
        if hints:
            _print(f"{CYAN}── hints ──{R}")
            for line in hints.splitlines():
                _print(f"   {GRAY}{line}{R}")
        else:
            _print(f"{GRAY}（無對應提示）{R}")


# ── on_save：儲存程式碼（純 I/O，無互動）────────────────────────────────────

def _make_on_save(problem_id: str, task: Task, experiment: str):
    def on_save(attempt: int, code: str) -> None:
        out_file = save_code(problem_id, attempt, code, task=task, experiment=experiment)
        _print(f"{GRAY}💾  saved → {out_file}{R}")
    return on_save


# ── on_checkpoint：顯示結果 + 人工介入（控制流）────────────────────────────

def _make_checkpoint():
    """
    回傳 on_checkpoint closure。
    儲存邏輯已移至 on_save，這裡只負責顯示結果與人工互動。
    嘗試次數交由使用者決定，不受 max_attempts 硬上限限制。
    """
    def on_checkpoint(attempt: int, result: dict, code: str) -> bool:

        # ── 顯示結果 ───────────────────────────────────────────────────────────
        if result["passed"]:
            _print(f"\n{GREEN}{BOLD}✅  simulation PASS — 呼叫 synthesize 驗證可合成性{R}")
            return True

        etype  = result["error_type"]
        mc     = result.get("mismatch_count", 0)
        mc_str = f"  (mismatches: {mc})" if mc > 0 else ""
        _print(f"\n{RED}❌  {etype}{R}{mc_str}")

        if result.get("error_log"):
            err_lines = result["error_log"].splitlines()
            for line in err_lines[:6]:
                _print(f"   {GRAY}{line}{R}")
            if len(err_lines) > 6:
                _print(f"   {GRAY}  … ({len(err_lines) - 6} more lines, 輸入 v 查看全部){R}")

        # ── 人工介入點（while 迴圈，v/c 看完後仍可繼續操作）─────────────────
        _print(f"\n{DLINE}")
        menu = (
            f"{CYAN}繼續讓 Agent 嘗試？{R}（第 {attempt} 次） "
            f"[{BOLD}Enter{R} 繼續 / "
            f"{BOLD}a{R} 中止 / "
            f"{BOLD}v{R} 完整 log / "
            f"{BOLD}c{R} 完整程式碼 / "
            f"{BOLD}h{R} 補充修改方向] > "
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
                    return hint   # str → agent 作為獨立 user turn 注入
                # hint 為空 → 當作 Enter 繼續
            else:
                return True

    return on_checkpoint


# ── 單題執行 ──────────────────────────────────────────────────────────────────

def run_problem(
    problem_id: str,
    task: Task,
    experiment: str = "agent",
    max_attempts: int = 5,
):
    if experiment not in _EXP_TOOLS:
        _print(f"{RED}未知 experiment: {experiment!r}，可用：{', '.join(VALID_EXPS)}{R}")
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

    result = run_agent(
        problem_id=problem_id,
        problem_description=problem_desc,
        task=task,
        max_attempts=max_attempts,
        verbose=False,
        enabled_tools=_EXP_TOOLS[experiment],
        on_thinking=_on_thinking,
        on_tool_call=_on_tool_call,
        on_tool_result=_on_tool_result,
        on_save=_make_on_save(problem_id, task, experiment),
        on_checkpoint=_make_checkpoint(),
    )

    save_result(problem_id, result, task=task, experiment=experiment)

    out_prefix = f"outputs/{experiment}/{task.name}/{problem_id}"
    _print(f"\n{DLINE}")
    sim_ok = result.get("sim_passed", result.get("passed", False))
    if result["passed"]:
        _print(f"{GREEN}{BOLD}🎉  完成！模擬✅ 合成✅  共 {result['attempts']} 次嘗試{R}")
        _print(f"📄  {out_prefix}/attempt_{result['attempts']}.sv")
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
