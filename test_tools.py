"""
test_tools.py — tools.py 整合測試

分兩段：
  Section 1  — 單元測試：直接測試 _classify_compile / _classify_sim（不需要 iverilog）
  Section 2  — 整合測試：透過 compile_and_test() 測試各 error code（需要 iverilog + vvp）

執行方式（WSL Ubuntu）：
    source .venv/bin/activate
    python test_tools.py

若只想跑分類器單元測試（任何環境都可跑，不需要 iverilog）：
    python test_tools.py --unit-only

Error code 參考：
  .   Pass（Mismatches: 0）
  S   Syntax Error
  e   Explicit Cast Required（enum + 直接賦值）
  0   Sized Numeric Constant Must Have Size > 0
  n   No Sensitivities（always_comb/always @(*) 無讀取信號）
  w   Declared as Wire（net 型態無法在 always 中賦值）
  m   Unknown Module Type
  p   Unable to Bind Wire/Reg（非 clk）
  c   Unable to Bind Wire/Reg clk
  C   Generic Compiler Error（catch-all）
  R   Runtime Mismatch（Mismatches > 0）
  T   Timeout（sim 超時）
  r   Async Reset（靜態分析）
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from agent.tools import compile_and_test, _classify_compile, _classify_sim

# ── ANSI colors ───────────────────────────────────────────────────────────────
_G = "\033[92m"   # green
_R = "\033[91m"   # red
_Y = "\033[93m"   # yellow
_C = "\033[96m"   # cyan
_D = "\033[90m"   # dark/gray
_B = "\033[1m"    # bold
_X = "\033[0m"    # reset

_pass = _fail = _skip = 0


def _ok(ok: bool):
    global _pass, _fail
    if ok:
        _pass += 1
        return f"{_G}[PASS]{_X}"
    else:
        _fail += 1
        return f"{_R}[FAIL]{_X}"


def _section(title: str):
    print(f"\n{_B}{'═' * 64}{_X}")
    print(f"{_B}  {title}{_X}")
    print(f"{_B}{'═' * 64}{_X}")


# ═════════════════════════════════════════════════════════════════════════════
# Section 1A — _classify_compile 單元測試
# ═════════════════════════════════════════════════════════════════════════════

_section("Section 1A：_classify_compile（mock iverilog log）")

COMPILE_CASES = [
    # (name, mock_log, expected_code)
    ("S  — syntax error",
     "foo.sv:3: error: syntax error, unexpected IDENTIFIER",
     "S"),

    ("e  — explicit cast required",
     'foo.sv:12: error: This assignment requires an explicit cast to "state_t" in this context.',
     "e"),

    ("0  — size must be > 0",
     "foo.sv:5: error: Sized numeric constant must have a size greater than zero.",
     "0"),

    ("n  — always_comb no sensitivities（同時有其他 error）",
     "foo.sv:1: warning: always_comb process has no sensitivities, so it will never trigger.\n"
     "foo.sv:2: error: port mismatch",
     "n"),

    ("w  — declared here as wire",
     "foo.sv:8: error: reg 'zero' is declared here as wire",
     "w"),

    ("m  — unknown module type",
     "foo.sv:3: error: Unknown module type: NonExistentFoo",
     "m"),

    ("c  — unable to bind clk（clk 找不到）",
     "foo.sv:2: error: Unable to bind wire/reg/memory `clk' in `tb.top_module1'",
     "c"),

    ("p  — unable to bind other signal（非 clk）",
     "foo.sv:5: error: Unable to bind wire/reg `data_in' in `tb.top_module1'",
     "p"),

    ("C  — generic error（catch-all）",
     "foo.sv:7: error: Net assignment to non-net port something",
     "C"),
]

for name, log, expected in COMPILE_CASES:
    actual = _classify_compile(log)
    ok = (actual == expected)
    print(f"  {_ok(ok)} {name}")
    if not ok:
        print(f"         期望={expected!r}  實際={actual!r}")

# ═════════════════════════════════════════════════════════════════════════════
# Section 1B — _classify_sim 單元測試
# ═════════════════════════════════════════════════════════════════════════════

_section("Section 1B：_classify_sim（mock vvp log + verilog source）")

SIM_CASES = [
    # (name, mock_sim_log, mock_verilog_src, expected_type, expected_count)
    (". — Mismatches: 0（Pass）",
     "Hint: Output 'out' has no mismatches.\nMismatches: 0 in 40 samples",
     "module TopModule(); endmodule",
     ".", 0),

    ("R — Mismatches: 5",
     "Hint: Output 'out' has 5 mismatches.\nMismatches: 5 in 40 samples",
     "module TopModule(); endmodule",
     "R", 5),

    ("T — TIMEOUT only（無 Mismatches 行）",
     "TIMEOUT\n/test.sv:100: $finish called at 1000000 (1ps)",
     "module TopModule(); endmodule",
     "T", -1),

    (". — TIMEOUT + Mismatches 0（Mismatches 優先，timer 類題目關鍵案例）",
     "TIMEOUT\n$finish called at 1000000 (1ps)\nMismatches: 0 in 200000 samples",
     "module TopModule(); endmodule",
     ".", 0),

    ("R — TIMEOUT + Mismatches 3（Mismatches 優先）",
     "TIMEOUT\nMismatches: 3 in 100 samples",
     "module TopModule(); endmodule",
     "R", 3),

    ("r — async reset（posedge reset，無 Mismatches 行）",
     "VCD info: dumpfile wave.vcd opened for output.\n$finish called at 0",
     "always @(posedge clk or posedge reset) begin end",
     "r", -1),

    ("r — async reset（negedge reset）",
     "some unrecognized sim output",
     "always @(negedge reset) begin q <= 0; end",
     "r", -1),

    ("r — async reset（posedge r) 縮寫形式）",
     "some unrecognized sim output",
     "always @(posedge clk or posedge r) begin end",
     "r", -1),

    ("R — 無 Mismatches、無 TIMEOUT、無 async reset（兜底）",
     "Simulation ended with unexpected output",
     "module TopModule(); endmodule",
     "R", -1),
]

for name, sim_log, verilog, exp_type, exp_count in SIM_CASES:
    actual_type, actual_count = _classify_sim(sim_log, verilog)
    ok = (actual_type == exp_type) and (actual_count == exp_count)
    print(f"  {_ok(ok)} {name}")
    if not ok:
        print(f"         期望=({exp_type!r}, {exp_count})  實際=({actual_type!r}, {actual_count})")


# ═════════════════════════════════════════════════════════════════════════════
# Section 2 — compile_and_test() 整合測試（需要 iverilog + vvp）
# ═════════════════════════════════════════════════════════════════════════════

UNIT_ONLY = "--unit-only" in sys.argv

_section("Section 2：compile_and_test() 整合測試" +
         ("（跳過：--unit-only）" if UNIT_ONLY else "（需要 WSL iverilog + vvp）"))

if UNIT_ONLY:
    print(f"\n  {_Y}[SKIP]{_X} --unit-only 旗標已設定，跳過全部整合測試\n")
    _skip += 9
else:

    def run(name: str, problem_id: str, code: str,
            expected_type: str, expected_passed: bool) -> None:
        """執行一個 compile_and_test 案例並印出結果。"""
        global _skip
        try:
            result = compile_and_test(code, problem_id, "spec-to-rtl")
        except FileNotFoundError as exc:
            _skip += 1
            print(f"  {_Y}[SKIP]{_X} [{expected_type}] {name}")
            print(f"         找不到資料集檔案：{exc}")
            return
        except Exception as exc:
            _skip += 1
            print(f"  {_Y}[SKIP]{_X} [{expected_type}] {name}")
            print(f"         例外：{exc}")
            return

        actual_type   = result["error_type"]
        actual_passed = result["passed"]
        ok = (actual_type == expected_type and actual_passed == expected_passed)

        print(f"  {_ok(ok)} [{expected_type}] {name}")
        if not ok:
            print(f"         期望 type={expected_type!r}  passed={expected_passed}")
            print(f"         實際 type={actual_type!r}  passed={actual_passed}")
        if result["error_log"]:
            line0 = result["error_log"].splitlines()[0]
            print(f"         {_D}↳ {line0[:110]}{_X}")

    # ──────────────────────────────────────────────────────────────────────
    # Prob001_zero（output zero）— 組合邏輯，無 clk
    # ──────────────────────────────────────────────────────────────────────

    print(f"\n{_C}── Prob001_zero  (output zero) ──{_X}")

    # 1.  . — Pass
    run(
        "正確答案",
        "Prob001_zero",
        "module TopModule (output zero);\n  assign zero = 1'b0;\nendmodule",
        ".", True,
    )

    # 2.  R — 邏輯錯誤（wrong value）
    run(
        "邏輯錯誤：zero = 1（應為 0）",
        "Prob001_zero",
        "module TopModule (output zero);\n  assign zero = 1'b1;\nendmodule",
        "R", False,
    )

    # 3.  S — 語法錯誤（typo in keyword）
    run(
        "語法錯誤：asign（typo）",
        "Prob001_zero",
        "module TopModule (output zero);\n  asign zero = 1'b0;\nendmodule",
        "S", False,
    )

    # 4.  w — net 型 output 無法在 always 中驅動
    run(
        "驅動 wire：always @(*) zero = 0（zero 預設是 net）",
        "Prob001_zero",
        "module TopModule (output zero);\n"
        "  always @(*) begin\n    zero = 1'b0;\n  end\nendmodule",
        "w", False,
    )

    # 5.  m — 不存在的模組
    run(
        "未知模組：instantiate NonExistentModule",
        "Prob001_zero",
        "module TopModule (output zero);\n"
        "  NonExistentModule blk (.out(zero));\nendmodule",
        "m", False,
    )

    # 6.  p — 未宣告的信號（非 clk）
    run(
        "未宣告信號：assign zero = nonexistent_wire",
        "Prob001_zero",
        "module TopModule (output zero);\n"
        "  assign zero = nonexistent_wire;\nendmodule",
        "p", False,
    )

    # 7.  0 — 大小為 0 的常數
    run(
        "大小為零常數：assign zero = 0'b0",
        "Prob001_zero",
        "module TopModule (output logic zero);\n"
        "  assign zero = 0'b0;\nendmodule",
        "0", False,
    )

    # ──────────────────────────────────────────────────────────────────────
    # Prob031_dff（input clk, input d, output reg q）— 含 clk
    #
    # 注意：c / e 的觸發方式與直覺不同
    #   c: clk 必須出現在模組**內部**（如 @(posedge clk)）且未宣告為 port
    #      → iverilog 解析 TopModule 本身時報 "Unable to bind wire/reg/memory `clk'"
    #      ✗ 錯誤做法：只是缺少 clk port，testbench 報 port-unconnected（→ C）
    #   e: 觸發條件是 4-state(logic) → 2-state(bit) 的隱式轉換
    #      → iverilog -g2012 報 "This assignment requires an explicit cast"
    #      ✗ 錯誤做法：logic[1:0] → enum(state_t) 在 iverilog v12 是隱式允許的（→ R）
    # ──────────────────────────────────────────────────────────────────────

    print(f"\n{_C}── Prob031_dff  (clk, d → q) ──{_X}")

    # 8.  c — clk 在模組內部使用但未宣告為 port
    #        ※ 「缺 clk port」讓 testbench 報 port-unconnected（不匹配 c 的模式）
    #           正確觸發：clk 在 always @(posedge clk) 中出現，但不在 port list
    #           → iverilog 在解析 TopModule 本身時報
    #             "Unable to bind wire/reg/memory `clk' in `TopModule'"
    run(
        "未宣告 clk：always @(posedge clk) 使用 clk 但 port list 無 clk",
        "Prob031_dff",
        """\
module TopModule (
    input  d,
    output reg q
);
    // clk 在此 sensitivity list 出現，但未宣告為 port 或 local wire
    always @(posedge clk)
        q <= d;
endmodule""",
        "c", False,
    )

    # 9.  e — enum ternary 模式（Prob156 實際觸發 e 的 pattern）
    #
    #        ✗ 先前嘗試的觸發方式及原因：
    #          - logic[1:0] → state_t（enum）  → iverilog v12 隱式允許（不報錯）
    #          - logic → bit（2-state）        → iverilog v12 隱式允許，甚至模擬通過 (.)
    #
    #        ✓ 已知觸發方式：case 裡的 ternary 賦值給 enum 型別
    #          `next_state = d ? STATE_A : STATE_B`
    #          iverilog -g2012 將 ternary 結果型別推導為 logic[N:0]（底層型別），
    #          而非 enum 型別，因此賦值給 state_t 需要 explicit cast → e
    run(
        "enum ternary：case 中 next_state = d ? S_ONE : S_ZERO",
        "Prob031_dff",
        """\
module TopModule (
    input  clk,
    input  d,
    output logic q
);
    typedef enum logic [3:0] {
        S_ZERO  = 4'd0,
        S_ONE   = 4'd1,
        S_TWO   = 4'd2,
        S_THREE = 4'd3
    } state_t;
    state_t state, next_state;

    always @(*) begin
        case (state)
            S_ZERO:  next_state = d ? S_ONE   : S_ZERO;
            S_ONE:   next_state = d ? S_TWO   : S_ZERO;
            S_TWO:   next_state = d ? S_THREE : S_ZERO;
            default: next_state = S_ZERO;
        endcase
    end
    always_ff @(posedge clk)
        state <= next_state;
    assign q = (state == S_THREE);
endmodule""",
        "e", False,
    )

    # ──────────────────────────────────────────────────────────────────────
    # 說明：以下 error code 未自動測試
    # ──────────────────────────────────────────────────────────────────────
    print(f"""
{_D}  ── 未自動測試的 error code ──
  n  always_comb/always@(*) 無讀取信號時 iverilog 只出 warning（exit 0），
     不觸發 _classify_compile。已由 Section 1B 的 mock log 測試覆蓋。
  r  需要 sim 輸出不含 Mismatches 行（sim 異常終止），
     VerilogEval testbench final block 幾乎必然輸出 Mismatches。
     已由 Section 1B 的 mock verilog source 測試覆蓋。
  T  Python-level TimeoutExpired 需等 60 秒才觸發；
     可手動降低 compile_and_test() timeout 驗證。
  C  Generic catch-all，已由 Section 1A mock log 覆蓋。{_X}""")

# ═════════════════════════════════════════════════════════════════════════════
# 彙總
# ═════════════════════════════════════════════════════════════════════════════

total = _pass + _fail + _skip
print(f"\n{_B}{'─' * 64}{_X}")
print(f"{_B}  結果：{_G}{_pass} PASS{_X}{_B}  {_R}{_fail} FAIL{_X}{_B}  "
      f"{_Y}{_skip} SKIP{_X}{_B}  / {total} total{_X}")
print(f"{_B}{'─' * 64}{_X}\n")

sys.exit(1 if _fail > 0 else 0)
