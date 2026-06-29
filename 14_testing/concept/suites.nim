# nim c -r suites.nim
# suite/test/check: the three-level structure of unittest. Suites group
# related tests. Tests describe behaviors. Checks verify conditions.

import std/unittest

# ── A pure proc to test ────────────────────────────────────────────────

proc reverse[T](s: seq[T]): seq[T] =
  result = @[]
  for i in countdown(s.len - 1, 0):
    result.add(s[i])

# ── Suite: named after the thing being tested ─────────────────────────

suite "reverse":
  # Suite-level bindings — shared across all tests in this suite.
  let sample = @[1, 2, 3]
  let single = @[42]
  let empty: seq[int] = @[]

  test "reverses a list":
    check reverse(sample) == @[3, 2, 1]
    check reverse(@[4, 5, 6]) == @[6, 5, 4]

  test "handles empty list":
    check reverse(empty).len == 0
    check reverse(empty) == empty

  test "reverses twice is identity":
    check reverse(reverse(sample)) == sample
    check reverse(reverse(@[1, 2, 3, 4, 5])) == @[1, 2, 3, 4, 5]

  test "single-element list is unchanged":
    check reverse(single) == single

  test "length is preserved":
    check reverse(sample).len == sample.len

# Output shows:  .....  and [OK] if all pass.
# One failure prints [FAILED] and the line but keeps running other tests.

# ── Naming conventions ─────────────────────────────────────────────────
#   suite "moduleOrProc"     → the unit under test
#   test "describes behavior" → what should happen
#   check condition           → one specific expectation

# Good test names:
#   test "reverses a list"               ← what behavior
#   test "handles empty list"            ← edge case
#   test "reverses twice is identity"    ← property

# Bad test names:
#   test "test1", test "basic"           ← too vague
#   test "reverse should work"           ← doesn't say what

# ── What happens outside suite? ────────────────────────────────────────
# This check runs at module top level — no suite context:
check @[1, 2, 3].len == 3

# It's valid but doesn't show a test name. Use suite/test for clarity.

# Try changing:
#   - Add a test for length-2 list reversal.
#   - Put a `check` outside any `test` block — what name shows on failure?
#   - Rename the suite and see how output changes.
#   - Add a deliberately failing test and see if other tests still run.
#   - Test with a seq of strings instead of ints.
