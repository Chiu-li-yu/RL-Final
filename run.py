#!/usr/bin/env python3
"""
互動式 Verilog Agent CLI — 簡化版 Claude Code 風格

這個檔案只負責「顯示與互動」，不碰檔案系統或資料集路徑：
  - 顯示 Gemini 的思考過程與工具呼叫（callbacks）
  - 每次 compile_and_test 後提供人工介入點
  - 儲存邏輯委派給 agent.dataset

關係：
  run.py  ──uses──>  agent.agent.run_agent()    (Agent 邏輯)
  run.py  ──uses──>  agent.dataset.save_code()  (儲存委派)
  run.py  ──uses──>  agent.dataset.load_problem() (題目讀取)

Usage:
    python run.py                                      # REPL 模式
    python run.py Prob001_zero                         # 直接執行（預設 spec-to-rtl）
    python run.py Prob001_zero code-complete-iccad2023 # 指定任務類型
"""

import sys
from dotenv import load_dotenv

load_dotenv()

from agent.agent import run_agent
from agent.dataset import load_problem, save_code, save_result

# ── ANSI 色碼 ─────────────────────────────────────────────────────────────────
R     = "\033[0m"       # Reset
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
    """Gemini 的思考文字（工具呼叫前的說明，或回應純文字）。"""
    _print(f"\n{GRAY}{text}{R}")


def _on_tool_call(name: str, args: dict, attempt: int):
    """工具即將被呼叫。"""
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

    elif name == "decompose_spec":
        desc = args.get("problem_description", "")
        _print(f"\n{YELLOW}🔍  decompose_spec{R}")
        _print(f"{GRAY}{desc[:200]}…{R}")

    elif name == "get_interface":
        _print(f"\n{YELLOW}🔌  get_interface{R}")


def _on_tool_result(name: str, result: dict, attempt: int):
    """工具執行完畢（顯示結果摘要）。"""
    if name == "decompose_spec":
        sub_goals = result.get("sub_goals", "")
        _print(f"{GRAY}{sub_goals[:400]}{R}")

    elif name == "get_interface":
        err = result.get("error", "")
        if err:
            _print(f"{RED}  介面查詢失敗：{err}{R}")
        else:
            ifc = result.get("interface", "")
            _print(f"{GRAY}{ifc}{R}")


def _make_checkpoint(problem_id: str, task: str, max_attempts: int):
    """
    建立 on_checkpoint callback（closure 帶入 problem_id, task）。
    每次 compile_and_test 完成後呼叫；回傳 False 表示使用者要求中止。

    儲存邏輯委派給 agent.dataset，此函式只負責顯示與互動。
    """
    def on_checkpoint(attempt: int, result: dict, code: str) -> bool:

        # ── 儲存程式碼（委派給 dataset） ──────────────────────────────────
        out_file = save_code(problem_id, attempt, code,
                             task=task, experiment="agent")
        _print(f"{GRAY}💾  saved → {out_file}{R}")

        # ── 顯示結果 ───────────────────────────────────────────────────────
        if result["passed"]:
            _print(f"\n{GREEN}{BOLD}✅  PASS{R}")
            return True  # 通過後 agent 會自動停止，直接繼續即可

        etype = result["error_type"]
        mc    = result.get("mismatch_count", 0)
        mc_str = f"  (mismatches: {mc})" if mc > 0 else ""
        _print(f"\n{RED}❌  {etype}{R}{mc_str}")

        # 顯示前 6 行 error log
        if result.get("error_log"):
            err_lines = result["error_log"].splitlines()
            for line in err_lines[:6]:
                _print(f"   {GRAY}{line}{R}")
            if len(err_lines) > 6:
                _print(f"   {GRAY}  … ({len(err_lines) - 6} more lines, 輸入 v 查看全部){R}")

        # 若有 debug_hints（R 類錯誤），顯示診斷提示
        if result.get("debug_hints"):
            _print(f"\n{CYAN}💡  Debug hints:{R}")
            for line in result["debug_hints"].splitlines():
                _print(f"   {GRAY}{line}{R}")

        # ── 若已到上限，不詢問 ─────────────────────────────────────────────
        if attempt >= max_attempts:
            return True

        # ── 人工介入點（while 迴圈，v/c 看完後仍可繼續操作）─────────────────
        _print(f"\n{DLINE}")
        menu = (
            f"{CYAN}繼續讓 Agent 嘗試？{R} "
            f"[{BOLD}Enter{R} 繼續 / "
            f"{BOLD}a{R} 中止 / "
            f"{BOLD}v{R} 完整 log / "
            f"{BOLD}c{R} 完整程式碼] > "
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
            else:
                return True  # Enter 或其他輸入 → 繼續

    return on_checkpoint


# ── 單題執行 ──────────────────────────────────────────────────────────────────

def run_problem(problem_id: str, task: str, max_attempts: int = 3):
    """執行單一題目，含互動式顯示。"""

    # 讀取題目描述（委派給 dataset）
    try:
        problem_desc = load_problem(problem_id, task)
    except FileNotFoundError:
        _print(f"{RED}找不到題目描述檔（problem_id={problem_id!r}, task={task!r}）{R}")
        _print("請確認 problem_id 拼法（例如 Prob001_zero）")
        return

    # 顯示題目資訊
    header(f"🎯  {problem_id}  [{task}]")
    _print(problem_desc[:600] + ("…" if len(problem_desc) > 600 else ""))
    _print(DLINE)

    # 建立 callbacks
    checkpoint = _make_checkpoint(problem_id, task, max_attempts)

    # 執行 agent
    result = run_agent(
        problem_id=problem_id,
        problem_description=problem_desc,
        task=task,
        max_attempts=max_attempts,
        verbose=False,
        on_thinking=_on_thinking,
        on_tool_call=_on_tool_call,
        on_tool_result=_on_tool_result,
        on_checkpoint=checkpoint,
    )

    # 儲存結果 JSON（委派給 dataset）
    save_result(problem_id, result, task=task, experiment="agent")

    # 最終摘要
    out_prefix = f"outputs/agent/{task}/{problem_id}"
    _print(f"\n{DLINE}")
    if result["passed"]:
        _print(f"{GREEN}{BOLD}🎉  完成！  共 {result['attempts']} 次嘗試{R}")
        _print(f"📄  {out_prefix}/attempt_{result['attempts']}.sv")
    else:
        _print(f"{RED}😞  未通過  共 {result['attempts']} 次嘗試{R}")
        if result["attempts"] > 0:
            _print(f"📄  {out_prefix}/attempt_{result['attempts']}.sv  （最後的程式碼）")
    _print(DLINE + "\n")


# ── REPL 主迴圈 ───────────────────────────────────────────────────────────────

def repl():
    header("🤖  Verilog Agent  Interactive Mode")
    _print("輸入 <problem_id> [task] 開始，task 預設 spec-to-rtl")
    _print("可用 task：spec-to-rtl  /  code-complete-iccad2023")
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

        parts = line.split()
        problem_id = parts[0]
        task = parts[1] if len(parts) > 1 else "spec-to-rtl"

        if task not in ("spec-to-rtl", "code-complete-iccad2023"):
            _print(f"{RED}未知 task：{task!r}{R}")
            continue

        run_problem(problem_id, task)


# ── Entry point ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    args = sys.argv[1:]

    if len(args) == 0:
        repl()
    elif len(args) == 1:
        run_problem(args[0], task="spec-to-rtl")
    elif len(args) == 2:
        run_problem(args[0], task=args[1])
    else:
        print(f"Usage: python run.py [problem_id] [task]")
        sys.exit(1)
