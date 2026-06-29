# nim c -r ex03_expect.nim
# Exercise 3: Write tests with expect for parseAge
#
# parseAge converts a string to an integer age (0-150). It raises
# ValueError for invalid input: negative, too large, or non-numeric.
# Your job: write tests using `expect` to verify exception behavior.

import std/unittest
import std/strutils

proc parseAge(s: string): int =
  ## Parse a string into an age (0–150). Raises ValueError on failure.
  if s.len == 0:
    raise newException(ValueError, "empty input")
  try:
    result = parseInt(s)
  except ValueError:
    raise newException(ValueError, "not a number: " & s)
  if result < 0:
    raise newException(ValueError, "age cannot be negative: " & s)
  if result > 150:
    raise newException(ValueError, "age too large: " & s)

# ── Your test suite ──────────────────────────────────────────────────────
# Uncomment and complete each test block:

suite "parseAge":
  # test "valid age":
  #   check parseAge("25") == ___
  #   check parseAge("0") == ___
  #   check parseAge("150") == ___

  # test "negative age raises ValueError":
  #   expect ___:
  #     discard parseAge("-5")

  # test "age over 150 raises ValueError":
  #   expect ___:
  #     discard parseAge("151")

  # test "non-numeric raises ValueError":
  #   expect ___:
  #     discard parseAge("abc")

  # test "empty string raises ValueError":
  #   expect ___:
  #     discard parseAge("")

  test "placeholder — uncomment the tests above and remove this":
    check true
