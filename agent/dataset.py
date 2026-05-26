"""
Problem loading and output saving — the single seam between the filesystem layout
and the rest of the codebase.

Who uses this module:
  run.py      (interactive CLI)  — load_problem, save_code, save_result
  evaluate.py (batch runner)     — load_problem, save_result
  agent.py                       — load_problem (via run.py / evaluate.py, not directly)

Why it exists:
  Without this module, both run.py and evaluate.py would each hard-code the
  verilog-eval/ and outputs/ directory layouts.  Moving to a different dataset
  structure would require hunting through two callers.  This module is the only
  place that knows where files live.

Directory layout (encapsulated here, invisible to callers):
  verilog-eval/
    dataset_spec-to-rtl/         ← 自然語言描述 + ref.sv + test.sv
    dataset_code-complete-iccad2023/
  outputs/
    {problem_id}/
      attempt_1.sv               ← 每次 compile_and_test 的程式碼
      attempt_2.sv
      result.json                ← {"passed", "attempts", "error_type", ...}
"""

import json
from pathlib import Path

_BASE_DIR = Path(__file__).parent.parent

# 兩種 task 的自然語言題目描述都放在 dataset_spec-to-rtl/
_PROMPT_DIRS: dict[str, Path] = {
    "spec-to-rtl":             _BASE_DIR / "verilog-eval" / "dataset_spec-to-rtl",
    "code-complete-iccad2023": _BASE_DIR / "verilog-eval" / "dataset_spec-to-rtl",
}

_OUTPUT_DIR = _BASE_DIR / "outputs"


def load_problem(problem_id: str, task: str) -> str:
    """
    讀取題目的自然語言描述。

    Args:
        problem_id: 題目 ID，例如 "Prob001_zero"
        task:       "spec-to-rtl" 或 "code-complete-iccad2023"

    Returns:
        題目描述字串（已 strip）

    Raises:
        ValueError:       未知的 task
        FileNotFoundError: 題目描述檔不存在
    """
    if task not in _PROMPT_DIRS:
        raise ValueError(f"Unknown task: {task!r}. Must be one of {list(_PROMPT_DIRS)}")
    prompt_file = _PROMPT_DIRS[task] / f"{problem_id}_prompt.txt"
    return prompt_file.read_text(encoding="utf-8").strip()


def save_code(problem_id: str, attempt: int, code: str) -> Path:
    """
    儲存程式碼到 outputs/{problem_id}/attempt_{attempt}.sv。

    Args:
        problem_id: 題目 ID
        attempt:    嘗試次數（1, 2, 3, ...）
        code:       Verilog 程式碼字串

    Returns:
        儲存的檔案路徑
    """
    out_dir = _OUTPUT_DIR / problem_id
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / f"attempt_{attempt}.sv"
    out_file.write_text(code, encoding="utf-8")
    return out_file


def save_result(problem_id: str, result: dict) -> Path:
    """
    儲存結果 JSON 到 outputs/{problem_id}/result.json。
    final_code 欄位不寫入 JSON（避免檔案過大；程式碼已儲存在 .sv 檔）。

    Args:
        problem_id: 題目 ID
        result:     run_agent() 的回傳值

    Returns:
        儲存的檔案路徑
    """
    out_dir = _OUTPUT_DIR / problem_id
    out_dir.mkdir(parents=True, exist_ok=True)
    compact = {k: v for k, v in result.items() if k != "final_code"}
    out_file = out_dir / "result.json"
    out_file.write_text(json.dumps(compact, ensure_ascii=False, indent=2), encoding="utf-8")
    return out_file
