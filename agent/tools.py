"""
Verilog subprocess tools — compile_and_test() is the only public function.

This module is deliberately narrow: it contains only code that calls external
processes (iverilog, vvp).  LLM calls (decompose_spec) and dataset I/O live in
their own modules so this one stays easy to unit-test and mock.

Error classification (3-class: pass / compile_error / simulation_error) is
inlined here because it is a single private helper with no independent callers;
extracting it to a separate module would add a layer of indirection without
adding leverage.
"""

import os
import re
import subprocess
import tempfile
from pathlib import Path


# ── 資料集路徑（相對於 repo 根目錄，在 WSL 下自動解析為 /mnt/d/...） ──────
_BASE_DIR = Path(__file__).parent.parent
_DATASET_DIRS: dict[str, Path] = {
    "code-complete-iccad2023": _BASE_DIR / "verilog-eval" / "dataset_code-complete-iccad2023",
    "spec-to-rtl":             _BASE_DIR / "verilog-eval" / "dataset_spec-to-rtl",
}


# ── 私有：錯誤分類（直接內嵌，無獨立呼叫者）────────────────────────────────
def _classify(compile_returncode: int, combined_output: str) -> tuple[str, int]:
    """
    三分類：pass / compile_error / simulation_error。

    Args:
        compile_returncode: iverilog 的 exit code（0 = 成功）
        combined_output:    iverilog stderr + vvp stdout 合併字串

    Returns:
        (error_type, mismatch_count)
        mismatch_count: pass=0；simulation_error=mismatch 數（-1 代表 TIMEOUT 或無法解析）
    """
    if compile_returncode != 0:
        return "compile_error", 0

    if "TIMEOUT" in combined_output:
        return "simulation_error", -1

    # 格式：Mismatches: 0 in 40 samples
    m = re.search(r"Mismatches:\s*(\d+)\s+in\s+\d+\s+samples", combined_output)
    if m:
        n = int(m.group(1))
        return ("pass", 0) if n == 0 else ("simulation_error", n)

    # 無法識別輸出格式，保守判定失敗
    return "simulation_error", -1


# ── 公開：唯一對外介面 ────────────────────────────────────────────────────────
def compile_and_test(verilog_code: str, problem_id: str, task: str) -> dict:
    """
    編譯並模擬 Verilog 程式碼。

    執行流程：
      1. 將 verilog_code 寫入暫存 .sv 檔
      2. iverilog -g2012 編譯（ref.sv + generated.sv + test.sv）
      3. vvp 模擬，解析 Mismatches 行

    Args:
        verilog_code: 完整的 TopModule Verilog 程式碼（module TopModule … endmodule）
        problem_id:   題目 ID，例如 "Prob001_zero"
        task:         "code-complete-iccad2023" 或 "spec-to-rtl"

    Returns:
        {
            "passed":         bool,
            "error_type":     "pass" | "compile_error" | "simulation_error",
            "error_log":      str,   # 通過時為空字串
            "mismatch_count": int    # pass=0；simulation_error=mismatch 數；TIMEOUT=-1
        }
    """
    if task not in _DATASET_DIRS:
        raise ValueError(f"Unknown task: {task!r}. Must be one of {list(_DATASET_DIRS)}")

    dataset_dir = _DATASET_DIRS[task]
    ref_sv  = dataset_dir / f"{problem_id}_ref.sv"
    test_sv = dataset_dir / f"{problem_id}_test.sv"

    # ── 寫暫存 generated.sv ──────────────────────────────────────────────────
    fd, gen_sv = tempfile.mkstemp(suffix=".sv")
    vvp_out = gen_sv.replace(".sv", ".vvp")

    try:
        os.write(fd, verilog_code.encode("utf-8"))
        os.close(fd)

        # ── Step 1：iverilog 編譯 ────────────────────────────────────────────
        compile_result = subprocess.run(
            ["iverilog", "-g2012", "-o", vvp_out,
             str(ref_sv), gen_sv, str(test_sv)],
            capture_output=True,
            text=True,
            timeout=30,
        )
        # iverilog 錯誤輸出到 stderr；stdout 通常為空
        compile_log = compile_result.stderr + compile_result.stdout

        error_type, _ = _classify(compile_result.returncode, compile_log)
        if error_type == "compile_error":
            return {
                "passed":         False,
                "error_type":     "compile_error",
                "error_log":      compile_log.strip(),
                "mismatch_count": 0,
            }

        # ── Step 2：vvp 模擬 ─────────────────────────────────────────────────
        sim_result = subprocess.run(
            ["vvp", vvp_out],
            capture_output=True,
            text=True,
            timeout=60,
        )
        # vvp 正常輸出到 stdout（含 Mismatches 那行）
        sim_log = sim_result.stdout + sim_result.stderr

        error_type, mismatch_count = _classify(0, sim_log)

        return {
            "passed":         error_type == "pass",
            "error_type":     error_type,
            "error_log":      "" if error_type == "pass" else sim_log.strip(),
            "mismatch_count": mismatch_count,
        }

    finally:
        # ── 清理暫存檔 ───────────────────────────────────────────────────────
        if os.path.exists(gen_sv):
            os.unlink(gen_sv)
        if os.path.exists(vvp_out):
            os.unlink(vvp_out)
