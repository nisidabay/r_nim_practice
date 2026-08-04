# nim c -r assertions.nim
# check vs require vs expect vs assert: four tools for different jobs.
# Knowing which to use makes tests clearer and failures more useful.

import std/unittest

# ── Proc under test — may raise an exception ──────────────────────────

proc divide(a, b: int): int =
  if b == 0:
    raise newException(DivByZeroDefect, "division by zero")
  result = a div b

# ── check: report failure, continue ───────────────────────────────────

suite "divide — check":
  test "normal division":
    check divide(10, 2) == 5
    check divide(9, 3) == 3
    check divide(7, 2) == 3     # integer division truncates

  # Uncomment to see check report failure and continue:
  # test "check reports failure but continues":
  #   # Both checks run even if the first fails.
  #   check divide(10, 2) == 5
  #   check divide(10, 2) == 99   # this fails — but we keep going
  #   check divide(6, 3) == 2     # still runs

# ── require: abort current test on failure ────────────────────────────

suite "divide — require":
  test "require aborts on failure":
    let x = divide(10, 2)
    require x > 0               # must pass or test aborts
    check divide(100, x) == 20  # only runs if require passed

  # Uncomment to see require abort a test:
  # test "require fails":
  #   require false              # test aborts here
  #   check true                 # never runs

# ── expect: verify an exception is raised ─────────────────────────────

suite "divide — expect":
  test "zero divisor raises DivByZeroDefect":
    expect DivByZeroDefect:
      discard divide(1, 0)

  test "nonzero divisor does NOT raise":
    check divide(5, 1) == 5     # no exception expected here

# ── Side-by-side comparison ───────────────────────────────────────────

# | Tool     | On failure     | Use case                        |
# |----------|----------------|---------------------------------|
# | check    | report, continue | most test assertions           |
# | require  | abort test       | prerequisite for further checks |
# | expect   | catch exception  | verify code raises correctly   |
# | assert   | crash program    | invariants in production code  |

# ── Why not use assert in tests? ──────────────────────────────────────
# assert false → SIGABRT, program dies, remaining tests never run.
# check  false → prints [FAILED], continues to next test.

# Uncomment to see assert crash the program:
# suite "assert demo":
#   test "assert crashes":
#     assert false                 # everything after this is dead
#     check true                   # never reached

# Rule of thumb:
#   assert   → inside your procs (preconditions, invariants)
#   check    → inside test blocks (behavior verification)
#   require  → inside tests when later checks depend on it
#   expect   → when testing error paths

# Try changing:
#   - Replace a `check` with `require` — how does failure behavior differ?
#   - Use `expect` with the wrong exception type — see what happens.
#   - Add a test where divide(-1, 0) also raises — does it?
#   - Move `assert false` into a test and compare with `check false`.
#   - Test for `ValueError` instead of `DivByZeroDefect` on divide by zero.

# ── Thinking in Nim ────────────────────────────
# Nim gives you four assertion tools with deliberately different failure
# semantics — check reports and continues, require aborts the test, expect
# catches exceptions, and assert crashes the program. Inside tests the
# unittest variants (check/require/expect) keep the whole suite alive, so
# one bad case does not hide the rest of your results.
