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

from agent.agent import run_agent, RateLimiter
from agent.task import get_task, Task
from agent.dataset import (
    list_problems,
    load_problem,
    load_result,
    result_exists,
    save_code,
    save_result,
)
from agent.experiments import ALL_EXPERIMENTS, Experiment, get_experiment

# ── ANSI colors ───────────────────────────────────────────────────────────────
R      = "\033[0m"
BOLD   = "\033[1m"
GREEN  = "\033[32m"
RED    = "\033[31m"
YELLOW = "\033[33m"
CYAN   = "\033[36m"
GRAY   = "\033[90m"

VALID_EXPS    = tuple(ALL_EXPERIMENTS.keys())
DEFAULT_MODEL = "gemini-3.1-flash-lite" # "gemma-4-31b-it"

# ── BatchObserver（batch 模式：儲存程式碼，無互動）──────────────────────────

class BatchObserver:
    """
    Batch-mode adapter for run_agent() callbacks.
    Holds per-problem context so closures are not needed.

    attempt_offset: used by no_memory runs to store
    attempt_1.sv … attempt_5.sv across independent sessions.
    """
    def __init__(
        self,
        problem_id: str,
        task: Task,
        experiment: str,
        attempt_offset: int = 0,
    ):
        self._problem_id     = problem_id
        self._task           = task
        self._experiment     = experiment
        self._attempt_offset = attempt_offset

    def on_save(self, attempt: int, code: str) -> None:
        save_code(
            self._problem_id,
            attempt + self._attempt_offset,
            code,
            task=self._task,
            experiment=self._experiment,
        )


# ── 通用實驗執行器 ────────────────────────────────────────────────────────────

def _run_experiment(
    exp: Experiment,
    problem_id: str,
    desc: str,
    task: Task,
    model: str,
    rate_limiter: RateLimiter | None,
) -> dict:
    """
    Execute one problem under the given Experiment config.

    independent_runs == 1: single session with memory (all experiments except no_memory).
    independent_runs  > 1: multiple independent sessions without memory (no_memory).
    """
    if exp.independent_runs == 1:
        obs = BatchObserver(problem_id, task, exp.id)
        return run_agent(
            problem_id=problem_id,
            problem_description=desc,
            task=task,
            max_attempts=exp.max_attempts,
            model=model,
            verbose=False,
            rate_limiter=rate_limiter,
            enabled_tools=exp.enabled_tools,
            binary_feedback=exp.binary_feedback,
            on_save=obs.on_save,
        )

    # no_memory: independent_runs independent single-attempt sessions
    last_result: dict = {}
    for run_idx in range(exp.independent_runs):
        obs = BatchObserver(problem_id, task, exp.id, attempt_offset=run_idx)
        result = run_agent(
            problem_id=problem_id,
            problem_description=desc,
            task=task,
            max_attempts=exp.max_attempts,
            model=model,
            verbose=False,
            rate_limiter=rate_limiter,
            enabled_tools=exp.enabled_tools,
            binary_feedback=exp.binary_feedback,
            on_save=obs.on_save,
        )
        result = dict(result)
        result["attempts"] = run_idx + 1
        last_result = result
        if result["passed"]:
            return result
    return last_result


def _run_one(
    experiment: str,
    problem_id: str,
    desc: str,
    task: Task,
    model: str,
    resume: bool,
    rate_limiter: RateLimiter | None,
) -> tuple[dict | None, bool]:
    """執行單一題目（由 ThreadPoolExecutor worker 呼叫）。"""
    if resume and result_exists(problem_id, task, experiment):
        return None, True

    exp = get_experiment(experiment)
    try:
        result = _run_experiment(exp, problem_id, desc, task, model, rate_limiter)
    except Exception as e:
        raise RuntimeError(f"{problem_id}: {e}") from e

    save_result(problem_id, result, task=task, experiment=experiment)
    return result, False


# ── 執行緒安全進度追蹤器 ───────────────────────────────────────────────────────

class _Progress:
    def __init__(self, total: int, experiment: str, task: Task):
        self._lock   = threading.Lock()
        self.total   = total
        self.done    = 0
        self.passed  = 0
        self.failed  = 0
        self.skipped = 0
        self.errors  = 0
        self._start  = time.monotonic()
        self.exp     = experiment
        self.task    = task.name
        self.pass_at: dict[int, int] = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
        self.total_attempts = 0  # 累計所有通過題目的嘗試次數
        self.error_count: dict[str, int] = {}  # 錯誤類型計數
        self.total_decompose  = 0  # 累計 decompose_spec 呼叫次數
        self.total_debug_hints = 0  # 累計 get_debug_hints 呼叫次數

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
                attempts = result.get("attempts", 0) if result else 0
                status = f"{GRAY}skip {attempts}{R}" if attempts else f"{GRAY}skip{R}"
                # skip 的題目根據歷史結果計入對應統計
                if result:
                    if result.get("passed"):
                        self.passed += 1
                        n = min(attempts, 5) if attempts else 1
                        self.pass_at[n] = self.pass_at.get(n, 0) + 1
                        self.total_attempts += attempts if attempts else 1
                    else:
                        # 未完全通過（包括 sim_passed 和完全失敗）都計入 failed
                        self.failed += 1
            elif result is None:
                self.errors += 1
                status = f"{RED}err {R}"
            elif result["passed"]:
                self.passed += 1
                attempts = result.get("attempts", 1)
                n = min(attempts, 5)
                self.pass_at[n] = self.pass_at.get(n, 0) + 1
                self.total_attempts += attempts  # 累計嘗試次數
                status = f"{GREEN}pass {attempts}{R}"
            elif result.get("sim_passed"):
                self.failed += 1
                attempts = result.get("attempts", 0)
                status = f"{YELLOW}sim✓ synth✗ {attempts}{R}" if attempts else f"{YELLOW}sim✓ synth✗{R}"
            else:
                self.failed += 1
                etype = result.get("sim_error_type") or result.get("error_type", "?")
                status = f"{RED}FAIL[{etype}]{R}"

            # 統計錯誤類型與輔助工具呼叫次數
            if result and result is not None:
                sim_seq = result.get("sim_error_sequence", [])
                synth_seq = result.get("synth_error_sequence", [])
                for err in sim_seq:
                    if err and err != ".":
                        self.error_count[err] = self.error_count.get(err, 0) + 1
                for err in synth_seq:
                    if err and err != "Y":
                        self.error_count[err] = self.error_count.get(err, 0) + 1
                self.total_decompose   += result.get("decompose_spec_calls", 0)
                self.total_debug_hints += result.get("get_debug_hints_calls", 0)

            elapsed = time.monotonic() - self._start
            rate    = self.done / elapsed if elapsed > 0 else 0
            eta     = (self.total - self.done) / rate if rate > 0 else 0
            pct     = self.done / self.total * 100
            avg_attempts = self.total_attempts / self.passed if self.passed > 0 else 0

            dc = result.get("decompose_spec_calls", 0) if result else 0
            gh = result.get("get_debug_hints_calls", 0) if result else 0
            tools_str = f"d={dc} h={gh}" if (dc or gh) else ""

            line = (
                f"{CYAN}[{self.exp}/{self.task}]{R} "
                f"{self.done:>3}/{self.total} ({pct:5.1f}%) "
                f"{GREEN}✓{self.passed}{R} {RED}✗{self.failed}{R} "
                f"avg_attempts={avg_attempts:.1f} "
                f"skip={self.skipped} err={self.errors}  "
                f"ETA {eta:>5.0f}s  "
                f"[{status}]{f'  {GRAY}{tools_str}{R}' if tools_str else ''}  {problem_id}"
            )
            if error_msg:
                line += f"  {RED}← {error_msg}{R}"
            print(line, flush=True)

    def finish(self):
        with self._lock:
            elapsed   = time.monotonic() - self._start
            pass_rate = self.passed / self.total * 100 if self.total > 0 else 0

            sep = "━" * 60
            print(f"\n{sep}")
            print(f"{BOLD}  {self.exp}  ×  {self.task}{R}")
            print(sep)
            print(f"  Total   : {self.total}")
            print(f"  {GREEN}{BOLD}Passed  : {self.passed}  ({pass_rate:.1f}%){R}")
            print(f"  {RED}Failed  : {self.failed}{R}")
            if self.skipped:
                print(f"  Skipped : {self.skipped}  (--resume)")
            if self.errors:
                print(f"  {YELLOW}Errors  : {self.errors}  (will retry on next run){R}")
            print(f"  Time    : {elapsed:.0f}s")

            if self.passed > 0 and any(self.pass_at.values()):
                print(f"\n  Pass by attempt:")
                for n in sorted(self.pass_at):
                    cnt = self.pass_at[n]
                    if cnt:
                        bar_len  = int(cnt / self.passed * 20)
                        bar_fill = "█" * bar_len
                        print(f"    attempt {n}: {cnt:>3}  {GREEN}{bar_fill}{R}")

            if self.error_count:
                print(f"\n  Error Distribution:")
                sorted_errors = sorted(self.error_count.items(), key=lambda x: x[1], reverse=True)
                for err_type, cnt in sorted_errors:
                    print(f"    {err_type}: {cnt:>3} times")

            done_nonzero = self.done - self.errors
            if done_nonzero > 0:
                print(f"\n  Tool Calls (total / avg per problem):")
                print(f"    decompose_spec  : {self.total_decompose:>4}  "
                      f"({self.total_decompose / done_nonzero:.2f} avg)")
                print(f"    get_debug_hints : {self.total_debug_hints:>4}  "
                      f"({self.total_debug_hints / done_nonzero:.2f} avg)")

            print(sep + "\n")


# ── 批次執行主函式 ────────────────────────────────────────────────────────────

def run_batch(
    experiment: str,
    task: Task,
    model: str = DEFAULT_MODEL,
    resume: bool = True,
    workers: int = 1,
    rpm: int = 0,
    dry_run: bool = False,
) -> None:
    """
    對指定 experiment × task 批次執行所有 156 題。
    """
    if experiment not in VALID_EXPS:
        print(f"{RED}未知 experiment: {experiment!r}{R}")
        sys.exit(1)

    # 建立速率限制器（單一實例，所有 worker 共用）
    rate_limiter = RateLimiter(rpm) if rpm > 0 else None

    problems = list_problems(task)
    total    = len(problems)

    rpm_str = f"{rpm} RPM  ({60/rpm:.1f}s/call)" if rpm > 0 else "unlimited"
    print(f"\n{'=' * 60}")
    print(f"  Experiment : {YELLOW}{BOLD}{experiment}{R}")
    print(f"  Task       : {CYAN}{task.name}{R}")
    print(f"  Model      : {model}")
    print(f"  Problems   : {total}")
    print(f"  Workers    : {workers}")
    print(f"  Rate limit : {rpm_str}")
    print(f"  Resume     : {resume}")
    print(f"  Dry run    : {dry_run}")
    print(f"{'=' * 60}\n")

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

    progress = _Progress(total, experiment, task)

    skip_set: set[str] = set()
    for pid in problems:
        if pid not in desc_map:
            continue
        if resume and result_exists(pid, task, experiment):
            skip_set.add(pid)
            # 讀取已存在的 result.json 以取得 attempts 值
            try:
                import json
                from pathlib import Path
                result_file = Path("outputs") / experiment / task.name / pid / "result.json"
                if result_file.exists():
                    skip_result = json.loads(result_file.read_text(encoding="utf-8"))
                    progress.update(skip_result, was_skipped=True, problem_id=pid)
                else:
                    progress.update(None, was_skipped=True, problem_id=pid)
            except Exception:
                progress.update(None, was_skipped=True, problem_id=pid)

    pending = [pid for pid in problems
               if pid in desc_map and pid not in skip_set]

    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = {
            pool.submit(
                _run_one,
                experiment, pid, desc_map[pid], task, model, resume, rate_limiter,
            ): pid
            for pid in pending
        }

        for future in as_completed(futures):
            pid = futures[future]
            try:
                result, was_skipped = future.result()
                progress.update(result, was_skipped, pid)
            except Exception as e:
                progress.update(None, False, pid, error_msg=str(e))

    progress.finish()


# ── CLI ───────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="VerilogEval 批次實驗執行器",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "範例:\n"
            "  python evaluate.py --exp agent --task spec-to-rtl --rpm 15\n"
            "  python evaluate.py --exp baseline_a --task spec-to-rtl -w 4\n"
            "  python evaluate.py --exp agent --task spec-to-rtl --dry-run\n"
        ),
    )

    parser.add_argument("--exp", "-e", default="agent", choices=VALID_EXPS,
                        metavar="EXP", help=f"實驗類型：{' | '.join(VALID_EXPS)}")
    parser.add_argument("--task", "-t", default="spec-to-rtl",
                        metavar="TASK", help="評估任務：spec-to-rtl | code-complete-iccad2023")
    parser.add_argument("--model", "-m", default=DEFAULT_MODEL,
                        help=f"Gemini model name（預設: {DEFAULT_MODEL}）")
    parser.add_argument("--workers", "-w", type=int, default=1,
                        help="並行 worker 數（預設: 1）")
    parser.add_argument("--rpm", type=int, default=15, metavar="N",
                        help="每分鐘最多 API 呼叫次數，0 表示不限速（預設: 15）")
    parser.add_argument("--no-resume", action="store_true",
                        help="強制重跑所有題目（忽略已有的 result.json）")
    parser.add_argument("--dry-run", action="store_true",
                        help="只列出待執行題目，不實際呼叫 API")

    args = parser.parse_args()

    try:
        task = get_task(args.task)
    except ValueError as e:
        print(f"{RED}{e}{R}")
        sys.exit(1)

    run_batch(
        experiment=args.exp,
        task=task,
        model=args.model,
        resume=not args.no_resume,
        workers=args.workers,
        rpm=args.rpm,
        dry_run=args.dry_run,
    )


if __name__ == "__main__":
    main()
