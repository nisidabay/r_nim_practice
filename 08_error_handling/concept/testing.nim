# nim c -r testing.nim
# Testing with std/unittest: suite, test, check, setup, assert vs check.

import std/unittest

# ── Basic test ─────────────────────────────────────────────────────────

proc add(a, b: int): int = a + b

suite "math":
  test "addition":
    check add(2, 2) == 4
    check add(-1, 1) == 0

# suite groups related tests together. test defines a single test case.
# check verifies a condition is true; if it fails, unittest reports it
# and continues running the rest of the tests.

# ── Running tests ──────────────────────────────────────────────────────
# nim c -r testing.nim
# Passing tests print a dot:  ...  and end with [OK].
# A failing test shows the file, line, and expected vs actual values.

# Uncomment the block below to see what a failure looks like:
# suite "failing demo":
#   test "this will fail":
#     check 2 + 2 == 5

# Output for a failure:
#   [FAILED] this will fail
#   Check failed: 2 + 2 == 5
#   2 + 2 was 4

# ── Testing with setup ─────────────────────────────────────────────────

import std/strutils   # needed for `in` operator on strings

suite "strings":
  let greeting = "Hello, Nim!"

  test "length":
    check greeting.len == 11

  test "contains":
    check "Nim" in greeting

# A let declared at suite level is shared across all tests in that suite.
# Each test sees the same binding — no per-test re-initialization in this
# simple case. For per-test setup/teardown, use setup and teardown procs.

# ── Assert vs check ────────────────────────────────────────────────────
# assert is built into the system module (always available, no import needed).
# check comes from std/unittest.

proc halveEven(x: int): int =
  assert x mod 2 == 0, "x must be even"     # crashes on failure
  result = x div 2

# assert: use for internal invariants — things that "can't happen."
# Crashes immediately on failure. Useful inside procs, not in tests.
check halveEven(10) == 5                     # check: use in tests

# check: use in test cases. Reports failure but keeps running other
# tests so you can see all failures at once, not just the first one.

# Key difference:
#   assert false  → SIGABRT, program dies, remaining tests never run
#   check false   → prints [FAILED], continues to next test

# Rule of thumb:
#   assert  → inside your library/program code (preconditions, invariants)
#   check   → inside test/test blocks (behavior verification)
