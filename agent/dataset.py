"""
Problem loading and output saving — the single seam between the filesystem layout
and the rest of the codebase.

Who uses this module:
  run.py      (interactive CLI)  — load_problem, save_code, save_result
  evaluate.py (batch runner)     — list_problems, result_exists, load_problem, save_result

All functions accept a Task object (from agent.task) rather than a task name
string.  Path resolution is done here; callers never hard-code directory layouts.

Directory layout (encapsulated here, invisible to callers):

  outputs/
    {experiment}/                     ← "agent" | "baseline_a" | "baseline_b"
      {task.name}/                    ← "spec-to-rtl" | "code-complete-iccad2023"
        {problem_id}/
          attempt_1.sv                ← 每次 compile_and_test 的程式碼
          attempt_2.sv
          result.json
"""

import json
from pathlib import Path

from agent.task import Task

_BASE_DIR   = Path(__file__).parent.parent
_OUTPUT_DIR = _BASE_DIR / "outputs"


# ── 公開：題目列舉 ─────────────────────────────────────────────────────────────

def list_problems(task: Task) -> list[str]:
    """
    回傳指定 task 的所有題目 ID，按字母排序。

    Returns:
        排序後的 problem_id 清單，例如 ["Prob001_zero", ..., "Prob156_..."]
    """
    return sorted(
        f.stem.removesuffix("_prompt")
        for f in task.prompt_dir.glob("*_prompt.txt")
    )


# ── 公開：斷點續跑用 ───────────────────────────────────────────────────────────

def result_exists(problem_id: str, task: Task, experiment: str) -> bool:
    """檢查該題目在指定實驗中是否已有 result.json。"""
    path = _OUTPUT_DIR / experiment / task.name / problem_id / "result.json"
    return path.exists()


# ── 公開：題目讀取 ─────────────────────────────────────────────────────────────

def load_problem(problem_id: str, task: Task) -> str:
    """
    讀取題目的自然語言描述。

    Raises:
        FileNotFoundError: 題目描述檔不存在
    """
    prompt_file = task.prompt_dir / f"{problem_id}_prompt.txt"
    return prompt_file.read_text(encoding="utf-8").strip()


# ── 公開：輸出儲存 ─────────────────────────────────────────────────────────────

def save_code(problem_id: str, attempt: int, code: str,
              task: Task, experiment: str) -> Path:
    """儲存程式碼到 outputs/{experiment}/{task.name}/{problem_id}/attempt_{attempt}.sv。"""
    out_dir = _OUTPUT_DIR / experiment / task.name / problem_id
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / f"attempt_{attempt}.sv"
    out_file.write_text(code, encoding="utf-8")
    return out_file


def save_result(problem_id: str, result: dict,
                task: Task, experiment: str) -> Path:
    """
    儲存結果 JSON 到 outputs/{experiment}/{task.name}/{problem_id}/result.json。

    final_code 欄位不寫入 JSON；task.name 與 experiment 自動注入。
    """
    out_dir = _OUTPUT_DIR / experiment / task.name / problem_id
    out_dir.mkdir(parents=True, exist_ok=True)
    compact = {k: v for k, v in result.items() if k != "final_code"}
    compact["task"]       = task.name
    compact["experiment"] = experiment
    out_file = out_dir / "result.json"
    out_file.write_text(json.dumps(compact, ensure_ascii=False, indent=2), encoding="utf-8")
    return out_file
