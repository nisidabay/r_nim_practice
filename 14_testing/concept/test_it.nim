# 14 Testing — Test It
# gradeFromScore: combines check, expect, and setup/teardown.
# Score percentage → letter grade with boundary edges and error paths.

import std/unittest

# ── The proc you'll test ──────────────────────────────────────────────

proc gradeFromScore*(score, maxScore: int): char =
  ## Convert score/maxScore to letter grade: A≥90% B≥80% C≥70% D≥60% F<60%
  if maxScore <= 0:
    raise newException(ValueError, "maxScore must be positive")
  if score < 0:
    raise newException(ValueError, "score cannot be negative")
  if score > maxScore:
    raise newException(ValueError, "score cannot exceed maxScore")

  let pct = score / maxScore
  if pct >= 0.90: 'A'
  elif pct >= 0.80: 'B'
  elif pct >= 0.70: 'C'
  elif pct >= 0.60: 'D'
  else: 'F'

# ── Test suite: boundary edges + error paths ──────────────────────────

suite "gradeFromScore":
  # Boundary edges — the exact cutoff points
  test "A: 90% and above":
    check gradeFromScore(90, 100) == 'A'
    check gradeFromScore(100, 100) == 'A'
    check gradeFromScore(9, 10) == 'A'

  test "B: 80-89% — just below A cutoff":
    check gradeFromScore(89, 100) == 'B'
    check gradeFromScore(80, 100) == 'B'
    check gradeFromScore(85, 100) == 'B'

  test "C: 70-79%":
    check gradeFromScore(79, 100) == 'C'
    check gradeFromScore(70, 100) == 'C'

  test "D: 60-69%":
    check gradeFromScore(69, 100) == 'D'
    check gradeFromScore(60, 100) == 'D'

  test "F: 59% at exactly 60 → D, not F":
    check gradeFromScore(59, 100) == 'F'
    check gradeFromScore(0, 100) == 'F'

  # Error paths with expect
  test "invalid: negative score":
    expect ValueError:
      discard gradeFromScore(-1, 100)

  test "invalid: score exceeds maxScore":
    expect ValueError:
      discard gradeFromScore(101, 100)

  test "invalid: maxScore is zero":
    expect ValueError:
      discard gradeFromScore(50, 0)

  # Non-100 maxScore
  test "works with non-100 maxScore":
    check gradeFromScore(18, 20) == 'A'    # 90%
    check gradeFromScore(12, 20) == 'D'    # 60%
    check gradeFromScore(11, 20) == 'F'    # 55%

# Run: nim c -r test_it.nim
# All tests should pass — the implementation above is complete.
# Use this as a model for writing your own test suites.

# Try changing:
#   - Change the 90% boundary from 'A' to 'A+' and see which tests break.
#   - Add a minimum maxScore test: gradeFromScore(50, 1) → ValueError.
#   - Test the exact score=60 boundary against both sides.
#   - Write a similar suite for a `temperatureAlert` proc.

# ── Thinking in Nim ────────────────────────────
# A Nim test for logic like grading stays inside the language: exceptions
# (±ValueError) are declared with the proc and verified with expect, while
# boundary edges are plain check comparisons. Nim's `div` integer division
# and float-to-char results compute the grade inline, so the test reads
# exactly like the logic it proves.
