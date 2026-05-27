#!/usr/bin/env python3
"""
evaluate.py — VerilogEval 批次實驗執行器

對三組實驗（agent / baseline_a / baseline_b）× 兩個任務（spec-to-rtl /
code-complete-iccad2023）各跑 156 題，統計 pass rate 並儲存每題結果。

三組實驗說明：
  agent      — 完整系統（3 次嘗試 + error feedback + decompose_spec）
  baseline_a — 單次生成，無 error feedback（衡量「沒有 Agent」的基準）
  baseline_b — 3 次獨立生成，互不共享歷史（排除多次嘗試的效果，
               單獨衡量 feedback 的價值）

Usage:
    python evaluate.py --exp agent --task spec-to-rtl
    python evaluate.py --exp baseline_a --task spec-to-rtl --workers 4
    python evaluate.py --exp baseline_b --task code-complete-iccad2023
    python evaluate.py --exp agent --task spec-to-rtl --dry-run
    python evaluate.py --exp agent --task spec-to-rtl --no-resume
"""

import argparse
import sys
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

from dotenv import load_dotenv

load_dotenv()

from agent.agent import run_agent
from agent.dataset import (
    list_problems,
    load_problem,
    result_exists,
    save_code,
    save_result,
)

# ── ANSI colors ───────────────────────────────────────────────────────────────
R      = "\033[0m"
BOLD   = "\033[1m"
GREEN  = "\033[32m"
RED    = "\033[31m"
YELLOW = "\033[33m"
CYAN   = "\033[36m"
GRAY   = "\033[90m"

VALID_EXPS    = ("agent", "baseline_a", "baseline_b")
VALID_TASKS   = ("spec-to-rtl", "code-complete-iccad2023")
DEFAULT_MODEL = "gemini-3.1-flash-lite"


# ── Checkpoint callback（batch 模式：儲存程式碼但不中斷 agent）───────────────

def _save_cb(
    problem_id: str,
    task: str,
    experiment: str,
    attempt_offset: int = 0,
):
    """
    回傳一個 on_checkpoint closure，在每次 compile_and_test 後儲存程式碼。
    永遠回傳 True（不中斷 agent）。

    attempt_offset：
      baseline_b 的三次獨立執行各自帶入 0 / 1 / 2，
      讓程式碼依序存成 attempt_1.sv / attempt_2.sv / attempt_3.sv。
    """
    def on_checkpoint(attempt: int, result: dict, code: str) -> bool:
        save_code(
            problem_id,
            attempt + attempt_offset,
            code,
            task=task,
            experiment=experiment,
        )
        return True  # 永不中斷

    return on_checkpoint


# ── 三組實驗執行函式 ──────────────────────────────────────────────────────────

def _run_agent(
    problem_id: str,
    desc: str,
    task: str,
    model: str,
) -> dict:
    """
    Agent 實驗：最多 3 次嘗試，包含 error feedback 與 decompose_spec。
    """
    return run_agent(
        problem_id=problem_id,
        problem_description=desc,
        task=task,
        max_attempts=3,
        model=model,
        verbose=False,
        on_checkpoint=_save_cb(problem_id, task, "agent"),
    )


def _run_baseline_a(
    problem_id: str,
    desc: str,
    task: str,
    model: str,
) -> dict:
    """
    Baseline A：單次生成，無 error feedback。
    衡量「沒有 Agent 迭代」的基準 pass rate。
    """
    return run_agent(
        problem_id=problem_id,
        problem_description=desc,
        task=task,
        max_attempts=1,
        model=model,
        verbose=False,
        on_checkpoint=_save_cb(problem_id, task, "baseline_a"),
    )


def _run_baseline_b(
    problem_id: str,
    desc: str,
    task: str,
    model: str,
) -> dict:
    """
    Baseline B：3 次完全獨立生成，各自建立新的 chat session，互不共享歷史。

    與 agent 的差異：agent 在嘗試之間傳遞 error log（feedback），
    baseline_b 不傳，但同樣允許最多 3 次機會。
    兩者都允許 3 次機會，這樣才能公平地隔離 feedback 的作用。

    程式碼依序存成 attempt_1.sv、attempt_2.sv、attempt_3.sv。
    result.json 的 attempts 欄位記錄「第幾次才成功」（1/2/3），
    或若全部失敗則為 3。
    """
    last_result: dict = {}

    for run_idx in range(3):      # run_idx: 0→attempt_1, 1→attempt_2, 2→attempt_3
        result = run_agent(
            problem_id=problem_id,
            problem_description=desc,
            task=task,
            max_attempts=1,
            model=model,
            verbose=False,
            on_checkpoint=_save_cb(
                problem_id, task, "baseline_b",
                attempt_offset=run_idx,
            ),
        )
        # 覆寫 attempts 欄位：1/2/3（對應第幾次獨立嘗試）
        result = dict(result)
        result["attempts"] = run_idx + 1
        last_result = result

        if result["passed"]:
            return result   # 早停：第一次成功即回傳

    return last_result      # 全部失敗，回傳最後一次結果


# ── 實驗分派 ──────────────────────────────────────────────────────────────────

_EXP_RUNNERS = {
    "agent":      _run_agent,
    "baseline_a": _run_baseline_a,
    "baseline_b": _run_baseline_b,
}


def _run_one(
    experiment: str,
    problem_id: str,
    desc: str,
    task: str,
    model: str,
    resume: bool,
) -> tuple[dict | None, bool]:
    """
    執行單一題目（由 ThreadPoolExecutor worker 呼叫）。

    Returns:
        (result, was_skipped)
        result=None  → 執行時發生例外（不儲存 result.json，下次可重試）
        was_skipped  → True 表示 resume=True 且已有 result.json
    """
    if resume and result_exists(problem_id, task, experiment):
        return None, True      # 已有結果，跳過

    runner = _EXP_RUNNERS[experiment]
    try:
        result = runner(problem_id, desc, task, model)
    except Exception as e:
        # 不儲存 result.json，讓下次 --resume 時可重試
        raise RuntimeError(f"{problem_id}: {e}") from e

    save_result(problem_id, result, task=task, experiment=experiment)
    return result, False


# ── 執行緒安全進度追蹤器 ───────────────────────────────────────────────────────

class _Progress:
    """
    執行緒安全的進度追蹤器（不依賴 tqdm）。

    每次 update() 都在持有 lock 的情況下列印一行進度，
    因此多個 worker 的輸出行不會交錯。
    """

    def __init__(self, total: int, experiment: str, task: str):
        self._lock   = threading.Lock()
        self.total   = total
        self.done    = 0
        self.passed  = 0
        self.failed  = 0
        self.skipped = 0
        self.errors  = 0
        self._start  = time.monotonic()
        self.exp     = experiment
        self.task    = task
        # 記錄每個 attempt 上的成功數（供最終摘要顯示）
        self.pass_at: dict[int, int] = {1: 0, 2: 0, 3: 0}

    def update(
        self,
        result: dict | None,
        was_skipped: bool,
        problem_id: str,
        error_msg: str = "",
    ):
        with self._lock:
            self.done += 1

            if was_skipped:
                self.skipped += 1
                status = f"{GRAY}skip{R}"
            elif result is None:
                self.errors += 1
                status = f"{RED}err {R}"
            elif result["passed"]:
                self.passed += 1
                n = min(result.get("attempts", 1), 3)
                self.pass_at[n] = self.pass_at.get(n, 0) + 1
                status = f"{GREEN}pass{R}"
            else:
                self.failed += 1
                etype = result.get("error_type", "?")
                status = f"{RED}FAIL[{etype}]{R}"

            elapsed = time.monotonic() - self._start
            rate    = self.done / elapsed if elapsed > 0 else 0
            eta     = (self.total - self.done) / rate if rate > 0 else 0
            pct     = self.done / self.total * 100

            line = (
                f"{CYAN}[{self.exp}/{self.task}]{R} "
                f"{self.done:>3}/{self.total} ({pct:5.1f}%) "
                f"{GREEN}✓{self.passed}{R} {RED}✗{self.failed}{R} "
                f"skip={self.skipped} err={self.errors}  "
                f"ETA {eta:>5.0f}s  "
                f"[{status}] {problem_id}"
            )
            if error_msg:
                line += f"  {RED}← {error_msg}{R}"
            print(line, flush=True)

    def finish(self):
        """列印最終摘要統計。"""
        with self._lock:
            elapsed   = time.monotonic() - self._start
            pass_rate = self.passed / self.total * 100 if self.total > 0 else 0

            sep = "━" * 60
            print(f"\n{sep}")
            print(f"{BOLD}  {self.exp}  ×  {self.task}{R}")
            print(sep)
            print(f"  Total   : {self.total}")
            print(
                f"  {GREEN}{BOLD}Passed  : {self.passed}  "
                f"({pass_rate:.1f}%){R}"
            )
            print(f"  {RED}Failed  : {self.failed}{R}")
            if self.skipped:
                print(f"  Skipped : {self.skipped}  (--resume)")
            if self.errors:
                print(f"  {YELLOW}Errors  : {self.errors}  "
                      f"(will retry on next run){R}")
            print(f"  Time    : {elapsed:.0f}s")

            # 成功題目的 attempt 分佈（僅限有成功題目時顯示）
            if self.passed > 0 and any(self.pass_at.values()):
                print(f"\n  Pass by attempt:")
                for n in sorted(self.pass_at):
                    cnt = self.pass_at[n]
                    if cnt:
                        bar_len  = int(cnt / self.passed * 20)
                        bar_fill = "█" * bar_len
                        print(
                            f"    attempt {n}: {cnt:>3}  "
                            f"{GREEN}{bar_fill}{R}"
                        )

            print(sep + "\n")


# ── 批次執行主函式 ────────────────────────────────────────────────────────────

def run_batch(
    experiment: str,
    task: str,
    model: str = DEFAULT_MODEL,
    resume: bool = True,
    workers: int = 4,
    dry_run: bool = False,
) -> None:
    """
    對指定 experiment × task 批次執行所有 156 題。

    Args:
        experiment: "agent" | "baseline_a" | "baseline_b"
        task:       "spec-to-rtl" | "code-complete-iccad2023"
        model:      Gemini model name
        resume:     True 表示跳過已有 result.json 的題目（斷點續跑）
        workers:    ThreadPoolExecutor 的 max_workers
                    注意 Gemini API 速率限制，建議 2–4
        dry_run:    True 表示只列出待執行題目，不呼叫 API
    """
    if experiment not in VALID_EXPS:
        print(f"{RED}未知 experiment: {experiment!r}{R}")
        sys.exit(1)
    if task not in VALID_TASKS:
        print(f"{RED}未知 task: {task!r}{R}")
        sys.exit(1)

    problems = list_problems(task)
    total    = len(problems)

    print(f"\n{'=' * 60}")
    print(f"  Experiment : {YELLOW}{BOLD}{experiment}{R}")
    print(f"  Task       : {CYAN}{task}{R}")
    print(f"  Model      : {model}")
    print(f"  Problems   : {total}")
    print(f"  Workers    : {workers}")
    print(f"  Resume     : {resume}")
    print(f"  Dry run    : {dry_run}")
    print(f"{'=' * 60}\n")

    # ── Dry run：只列出待執行題目 ──────────────────────────────────────────
    if dry_run:
        will_run = [
            pid for pid in problems
            if not (resume and result_exists(pid, task, experiment))
        ]
        print(f"[dry-run] 以下 {len(will_run)}/{total} 題將被執行：")
        for pid in will_run:
            print(f"  {pid}")
        skipped = total - len(will_run)
        if skipped:
            print(f"\n  ({skipped} 題已有 result.json，--resume 時跳過)")
        return

    # ── 預先讀取所有題目描述（在主執行緒批次讀取，避免 worker 間競態）──────
    print("讀取題目描述 ...", end="", flush=True)
    desc_map: dict[str, str] = {}
    missing: list[str] = []
    for pid in problems:
        try:
            desc_map[pid] = load_problem(pid, task)
        except FileNotFoundError:
            missing.append(pid)
    if missing:
        print(f"\n{YELLOW}[WARN] 找不到 {len(missing)} 題的描述檔，將跳過：{R}")
        for pid in missing:
            print(f"  {pid}")
    print(f" {len(desc_map)} 題已載入")

    # ── 進度追蹤器 ────────────────────────────────────────────────────────
    progress = _Progress(total, experiment, task)

    # ── 先把 resume 可跳過的題目計入進度（讓百分比從一開始就正確）─────────
    skip_set: set[str] = set()
    for pid in problems:
        if pid not in desc_map:
            continue
        if resume and result_exists(pid, task, experiment):
            skip_set.add(pid)
            progress.update(None, was_skipped=True, problem_id=pid)

    # ── ThreadPoolExecutor 並行執行 ────────────────────────────────────────
    pending = [pid for pid in problems
               if pid in desc_map and pid not in skip_set]

    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = {
            pool.submit(
                _run_one,
                experiment, pid, desc_map[pid], task, model, resume,
            ): pid
            for pid in pending
        }

        for future in as_completed(futures):
            pid = futures[future]
            try:
                result, was_skipped = future.result()
                progress.update(result, was_skipped, pid)
            except Exception as e:
                # _run_one 拋出例外（API 失敗等）→ 不儲存結果，下次可重試
                progress.update(None, False, pid, error_msg=str(e))

    progress.finish()


# ── CLI ───────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="VerilogEval 批次實驗執行器",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "範例:\n"
            "  python evaluate.py --exp agent --task spec-to-rtl\n"
            "  python evaluate.py --exp baseline_a --task spec-to-rtl -w 4\n"
            "  python evaluate.py --exp agent --task spec-to-rtl --dry-run\n"
            "  python evaluate.py --exp baseline_b --task code-complete-iccad2023 --no-resume"
        ),
    )

    parser.add_argument(
        "--exp", "-e",
        required=True,
        choices=VALID_EXPS,
        metavar="EXP",
        help=f"實驗類型：{' | '.join(VALID_EXPS)}",
    )
    parser.add_argument(
        "--task", "-t",
        required=True,
        choices=VALID_TASKS,
        metavar="TASK",
        help=f"評估任務：{' | '.join(VALID_TASKS)}",
    )
    parser.add_argument(
        "--model", "-m",
        default=DEFAULT_MODEL,
        help=f"Gemini model name（預設: {DEFAULT_MODEL}）",
    )
    parser.add_argument(
        "--workers", "-w",
        type=int,
        default=4,
        help="並行 worker 數（建議 2–4，注意 Gemini API 速率限制；預設: 4）",
    )
    parser.add_argument(
        "--no-resume",
        action="store_true",
        help="強制重跑所有題目（忽略已有的 result.json）",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="只列出待執行題目，不實際呼叫 API",
    )

    args = parser.parse_args()

    run_batch(
        experiment=args.exp,
        task=args.task,
        model=args.model,
        resume=not args.no_resume,
        workers=args.workers,
        dry_run=args.dry_run,
    )


if __name__ == "__main__":
    main()
