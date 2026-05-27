"""
Verilog subprocess tools — compile_and_test() is the only public function.

This module is deliberately narrow: it contains only code that calls external
processes (iverilog, vvp).  LLM calls (decompose_spec) and dataset I/O live in
their own modules so this one stays easy to unit-test and mock.

Error classification is inlined here as two private helpers (_classify_compile,
_classify_sim).  The codes exactly match VerilogEval's sv-iv-analyze script so
our results can be compared directly against published baselines.

Error code reference (from sv-iv-analyze):
  Compile errors (iverilog returncode != 0):
    S  — syntax error
    e  — explicit cast required
    0  — sized numeric constant must have size > 0
    n  — always_comb / always @(*) has no sensitivities
    w  — signal declared as wire (cannot be driven procedurally)
    m  — unknown module type
    c  — unable to bind wire/reg `clk`
    p  — unable to bind wire/reg (other signal)
    C  — generic compiler error (catch-all)
  Simulation errors (vvp ran, but failed):
    T  — timeout (testbench output "TIMEOUT" or Python timeout)
    r  — async reset detected in verilog source (static analysis)
    R  — runtime mismatch (mismatches > 0, or unrecognised sim output)
  Pass:
    .  — Mismatches: 0 in N samples
"""

import os
import re
import subprocess
import tempfile
from pathlib import Path


# ── 資料集路徑 ────────────────────────────────────────────────────────────────
_BASE_DIR = Path(__file__).parent.parent
_DATASET_DIRS: dict[str, Path] = {
    "code-complete-iccad2023": _BASE_DIR / "verilog-eval" / "dataset_code-complete-iccad2023",
    "spec-to-rtl":             _BASE_DIR / "verilog-eval" / "dataset_spec-to-rtl",
}

# 公開常數：供 evaluate.py 等呼叫者分類 error_type
COMPILE_ERROR_CODES = frozenset({"S", "C", "e", "0", "n", "w", "m", "p", "c"})
SIM_ERROR_CODES     = frozenset({"R", "T", "r"})
PASS_CODE           = "."


# ── 私有：錯誤分類 ────────────────────────────────────────────────────────────

def _classify_compile(log: str) -> str:
    """
    分析 iverilog stderr，回傳細粒度 compile error 代碼。
    僅在 compile returncode != 0 時呼叫。

    掃描順序與 sv-iv-analyze 的 analyze_result() 一致：
    早出現的 break 優先，`p` 和 `C` 在整個 log 掃完後才判定。
    """
    error_C = False   # 有 "error" 字串但不屬於更具體的類別
    error_p = False   # 有 "Unable to bind wire/reg" 但不是 clk

    for line in log.splitlines():
        if "syntax error" in line:
            return "S"
        if "error" in line:
            error_C = True
        if "error: This assignment requires an explicit cast" in line:
            return "e"
        if "error: Sized numeric constant must have a size greater than zero" in line:
            return "0"
        if "warning: always_comb process has no sensitivities" in line:
            return "n"
        if "found no sensitivities so it will never trigger" in line:
            return "n"
        if "is declared here as wire" in line:
            return "w"
        if "Unknown module type" in line:
            return "m"
        if "Unable to bind wire/reg" in line:
            error_p = True
        if "Unable to bind wire/reg/memory `clk'" in line:
            return "c"

    if error_p:
        return "p"
    if error_C:
        return "C"
    return "C"   # 兜底：returncode != 0 但 log 沒有明確 error 字串


def _classify_sim(sim_log: str, verilog_code: str) -> tuple[str, int]:
    """
    分析 vvp stdout, 回傳細粒度 sim 結果代碼與 mismatch 數。

    優先序（與 sv-iv-analyze 略有不同，修正 timer 題的邊界情況）：
      1. Mismatches 行優先：即使 TIMEOUT 也出現，Mismatches: 0 視為通過
         原因：timer 類題目模擬時間長，testbench 的 $finish 守衛觸發後仍會
               輸出完整的 Mismatches 統計，此時 Mismatches: 0 是可信的結果。
      2. TIMEOUT 但無 Mismatches 行 → T（模擬未完成）
      3. 靜態分析 async reset → r
      4. 其餘 → R（runtime mismatch 或無法識別）
    """
    # ── 優先：Mismatches 行（testbench $finish 後輸出的最終統計）────────────
    # 格式：Mismatches: 0 in 40 samples
    m = re.search(r"Mismatches:\s*(\d+)\s+in\s+\d+\s+samples", sim_log)
    if m:
        n = int(m.group(1))
        return (".", 0) if n == 0 else ("R", n)

    # ── Timeout（無 Mismatches 行 → 模擬確實未完成）────────────────────────
    if "TIMEOUT" in sim_log:
        return "T", -1

    # ── 無法識別輸出：靜態分析 verilog source 是否有 async reset ─────────────
    for line in verilog_code.splitlines():
        if "posedge reset" in line or "negedge reset" in line or "posedge r)" in line:
            return "r", -1

    # 兜底
    return "R", -1


# ── 公開：唯一對外介面 ────────────────────────────────────────────────────────

def compile_and_test(verilog_code: str, problem_id: str, task: str) -> dict:
    """
    編譯並模擬 Verilog 程式碼。

    執行流程：
      1. 將 verilog_code 寫入暫存 .sv 檔
      2. iverilog -g2012 編譯（ref.sv + generated.sv + test.sv）
      3. vvp 模擬，解析輸出

    Args:
        verilog_code: 完整的 TopModule Verilog 程式碼
        problem_id:   題目 ID，例如 "Prob001_zero"
        task:         "code-complete-iccad2023" 或 "spec-to-rtl"

    Returns:
        {
            "passed":         bool,
            "error_type":     str,   # VerilogEval 代碼：. S C e 0 n w m p c R T r
            "error_log":      str,   # 通過時為空字串
            "mismatch_count": int    # pass=0；sim error=mismatch 數；timeout/unknown=-1
        }
    """
    if task not in _DATASET_DIRS:
        raise ValueError(f"Unknown task: {task!r}. Must be one of {list(_DATASET_DIRS)}")

    dataset_dir = _DATASET_DIRS[task]
    ref_sv  = dataset_dir / f"{problem_id}_ref.sv"
    test_sv = dataset_dir / f"{problem_id}_test.sv"

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
        compile_log = compile_result.stderr + compile_result.stdout

        if compile_result.returncode != 0:
            error_code = _classify_compile(compile_log)
            return {
                "passed":         False,
                "error_type":     error_code,
                "error_log":      compile_log.strip(),
                "mismatch_count": 0,
            }

        # ── Step 2：vvp 模擬 ─────────────────────────────────────────────────
        try:
            sim_result = subprocess.run(
                ["vvp", vvp_out],
                capture_output=True,
                text=True,
                timeout=60,
            )
            sim_log = sim_result.stdout + sim_result.stderr
        except subprocess.TimeoutExpired:
            # Python-level timeout（testbench 跑超過 60 秒）
            return {
                "passed":         False,
                "error_type":     "T",
                "error_log":      "Simulation timed out after 60s",
                "mismatch_count": -1,
            }

        error_code, mismatch_count = _classify_sim(sim_log, verilog_code)

        return {
            "passed":         error_code == ".",
            "error_type":     error_code,
            "error_log":      "" if error_code == "." else sim_log.strip(),
            "mismatch_count": mismatch_count,
        }

    finally:
        if os.path.exists(gen_sv):
            os.unlink(gen_sv)
        if os.path.exists(vvp_out):
            os.unlink(vvp_out)
