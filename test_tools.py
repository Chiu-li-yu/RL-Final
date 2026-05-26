"""
工具層驗證腳本：直接呼叫 compile_and_test()，不涉及 Gemini。

執行方式（WSL Ubuntu）：
  cd /mnt/d/Desktop/GitHub/School/強化學習期末專題
  source .venv/bin/activate
  python test_tools.py
"""

from agent.tools import compile_and_test

PASS  = "✅ PASS"
FAIL  = "❌ FAIL"


def check(label: str, result: dict, expect_passed: bool, expect_type: str) -> bool:
    ok_passed = result["passed"] == expect_passed
    ok_type   = result["error_type"] == expect_type
    status    = PASS if (ok_passed and ok_type) else FAIL
    print(f"{status}  {label}")
    print(f"       passed={result['passed']}  error_type={result['error_type']!r}"
          f"  mismatch_count={result['mismatch_count']}")
    if not (ok_passed and ok_type):
        print(f"       ⚠ 期望 passed={expect_passed}  error_type={expect_type!r}")
        if result["error_log"]:
            # 只印前 10 行，避免太長
            lines = result["error_log"].splitlines()
            preview = "\n".join(lines[:10])
            if len(lines) > 10:
                preview += f"\n       ... ({len(lines) - 10} more lines)"
            print(f"       error_log:\n{preview}")
    return ok_passed and ok_type


def main():
    print("=" * 60)
    print("Verilog Tools Layer 驗證")
    print("=" * 60)

    results = []

    # ── 測試 1：正確解 → 期望 pass ──────────────────────────────────────
    correct_code = """\
module TopModule (
  output zero
);
  assign zero = 1'b0;
endmodule
"""
    r = compile_and_test(correct_code, "Prob001_zero", "code-complete-iccad2023")
    results.append(check(
        "Prob001_zero  正確解（assign zero = 1'b0）",
        r, expect_passed=True, expect_type="pass",
    ))

    # ── 測試 2：邏輯錯誤 → 期望 simulation_error ────────────────────────
    wrong_logic_code = """\
module TopModule (
  output zero
);
  assign zero = 1'b1;   // 邏輯錯誤：應輸出 0，此處輸出 1
endmodule
"""
    r = compile_and_test(wrong_logic_code, "Prob001_zero", "code-complete-iccad2023")
    results.append(check(
        "Prob001_zero  邏輯錯誤（assign zero = 1'b1）",
        r, expect_passed=False, expect_type="simulation_error",
    ))

    # ── 測試 3：語法錯誤 → 期望 compile_error ───────────────────────────
    syntax_error_code = """\
module TopModule (
  output zero
);
  assign zero = ;   // 語法錯誤：缺少運算式
endmodule
"""
    r = compile_and_test(syntax_error_code, "Prob001_zero", "code-complete-iccad2023")
    results.append(check(
        "Prob001_zero  語法錯誤（assign zero = ;）",
        r, expect_passed=False, expect_type="compile_error",
    ))

    # ── 測試 4：spec-to-rtl 任務 → 正確解 ──────────────────────────────
    r = compile_and_test(correct_code, "Prob001_zero", "spec-to-rtl")
    results.append(check(
        "Prob001_zero  spec-to-rtl 任務 正確解",
        r, expect_passed=True, expect_type="pass",
    ))

    # ── 摘要 ─────────────────────────────────────────────────────────────
    print("=" * 60)
    passed_count = sum(results)
    total = len(results)
    print(f"結果：{passed_count}/{total} 項通過")
    if passed_count == total:
        print("🎉 所有測試通過！工具層運作正常。")
    else:
        print("⚠  部分測試失敗，請檢查上方錯誤訊息。")
    print("=" * 60)


if __name__ == "__main__":
    main()
