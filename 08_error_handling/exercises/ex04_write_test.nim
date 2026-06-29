# nim c -r ex04_write_test.nim
# Exercise 4: Write a unittest
# Extension: see full exercise set → 14_testing/exercises/
#
# The function below is correct. Your job is to write a test suite
# that verifies it handles all cases correctly.

import std/unittest
import std/strutils

func parseScore(text: string): int =
  ## Convert "score: 42" → 42. Returns -1 on invalid input.
  if text.startsWith("score: "):
    try:
      return text[7..^1].strip().parseInt()
    except ValueError:
      return -1
  else:
    return -1

# ── Your test goes here ──────────────────────────────────────────────────
# Uncomment and complete:
#
# suite "parseScore":
#   test "valid score":
#     check parseScore("score: 42") == ___
#
#   test "missing score":
#     check parseScore("nope") == ___
#
#   test "empty string":
#     check parseScore("") == ___
