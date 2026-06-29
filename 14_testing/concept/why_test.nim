# nim c -r why_test.nim
# Why automated testing? Manual echo-checking is fragile and doesn't scale.

import std/unittest

# ── The manual way (what we used to do) ────────────────────────────────

proc isEven(n: int): bool = n mod 2 == 0

# Manual test — you check by eye:
echo "isEven(2) = ", isEven(2)    # true  ✓
echo "isEven(3) = ", isEven(3)    # false ✓

# Problems with manual checking:
#   1. You need to re-run AND re-read output every time you change code.
#   2. There's no report — you scan output with your eyes.
#   3. You can't easily test edge cases (0, negative, large numbers).
#   4. If you add a feature, old tests aren't re-run automatically.

# ── Automated: the testing way ─────────────────────────────────────────

suite "isEven":
  test "even numbers return true":
    check isEven(2)
    check isEven(0)
    check isEven(-4)
    check isEven(100)

  test "odd numbers return false":
    check not isEven(1)
    check not isEven(3)
    check not isEven(-1)

# Run this file: nim c -r why_test.nim
# Passing tests print a dot:  ..  and end with [OK].
# A failing test shows the file, line, and expected vs actual.

# ── What a failure looks like ──────────────────────────────────────────

# Uncomment this block to see a failure:
# suite "deliberate failure":
#   test "this WILL fail":
#     check isEven(7)  # true? No — 7 is odd. You'll see [FAILED].

# Output for a failure:
#   [FAILED] this WILL fail
#   Check failed: isEven(7)
#   isEven(7) was false

# ── Assert vs check (in tests) ─────────────────────────────────────────
# assert isEven(4)    # crashes on failure, remaining tests never run
# check  isEven(4)    # reports failure, continues to next test

# Rule of thumb:
#   assert  → inside your library/program code (preconditions)
#   check   → inside test blocks (behavior verification)

# Try changing:
#   - Add a proc `isOdd` and write tests for it.
#   - Change isEven to `n mod 3 == 0` and see which tests break.
#   - Replace a `check` with `assert` and compare failure behavior.
#   - Add a test for very large numbers (> 2^31).
#   - Move tests outside `suite` — what happens?
