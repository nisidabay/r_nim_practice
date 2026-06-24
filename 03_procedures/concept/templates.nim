# Templates inject code at the call site (like hygienic C macros).
# Macros manipulate the AST at compile time (like typed Lisp macros).

# ── Template: arguments are NOT evaluated before insertion ────────────
# This avoids evaluating expensive expressions in dead code paths.

proc expensiveCalc(): int =
  echo "EXPENSIVE: this runs!"
  42

template debugLog(msg: string, value: int) =
  when defined(debug):
    echo "[DEBUG] ", msg, ": ", value

debugLog("computation", expensiveCalc())
# In normal debug mode, expensiveCalc() runs and prints.
# Compile with -d:release — expensiveCalc() never runs!


# ── Template that repeats code: evaluate the body twice ───────────────

template twice(expr: untyped): untyped =
  expr; expr

var count = 0
twice: count += 1
echo count   # 2 — body was injected twice
