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

# ref.sv 中含有 initial block 且移除後無法由 LLM 自行補回的題目。
# 這些題目的正解依賴 initial 設定上電初始值，yosys generic synth 不支援，
# 因此從實驗資料集中排除，避免合成階段對正確答案誤判為失敗。
# （Prob031 的正解不需要 initial 也能通過，故保留。）
_SYNTH_EXCLUDED: frozenset[str] = frozenset({
    # "Prob034_dff8",
    # "Prob053_m2014_q4d",
    # "Prob104_mt2015_muxdff",
})


# ── 公開：題目列舉 ─────────────────────────────────────────────────────────────

def list_problems(task: Task) -> list[str]:
    """
    回傳指定 task 的題目 ID，按字母排序。

    排除 _SYNTH_EXCLUDED 中的題目（ref.sv 含有 initial，
    yosys 合成驗證會對正確答案誤判為失敗）。

    Returns:
        排序後的 problem_id 清單（153 題）
    """
    return sorted(
        f.stem.removesuffix("_prompt")
        for f in task.prompt_dir.glob("*_prompt.txt")
        if f.stem.removesuffix("_prompt") not in _SYNTH_EXCLUDED
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
    儲存結果到 outputs/{experiment}/{task.name}/{problem_id}/：
      result.json — 統計數據（排除 final_code、run_log）
      run.log     — 完整執行紀錄（若 result 含 run_log 則寫入）
    """
    out_dir = _OUTPUT_DIR / experiment / task.name / problem_id
    out_dir.mkdir(parents=True, exist_ok=True)

    _EXCLUDE = {"final_code", "run_log"}
    compact = {k: v for k, v in result.items() if k not in _EXCLUDE}
    compact["task"]       = task.name
    compact["experiment"] = experiment
    out_file = out_dir / "result.json"
    out_file.write_text(json.dumps(compact, ensure_ascii=False, indent=2), encoding="utf-8")

    if "run_log" in result:
        log_file = out_dir / "run.log"
        log_file.write_text("\n".join(result["run_log"]), encoding="utf-8")

    return out_file
