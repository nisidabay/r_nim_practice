# nim c -r ex01_test_check.nim
# Exercise 1: Write tests for parseCsvLine
#
# parseCsvLine splits a CSV line on commas, strips whitespace,
# and handles quoted fields (quotes are removed). The function is
# correct. Your job is to complete the test suite below.

import std/unittest
import std/strutils

proc parseCsvLine(line: string): seq[string] =
  ## Split a CSV line on commas. Handles quoted fields.
  var fields: seq[string] = @[]
  var current = ""
  var inQuotes = false
  for ch in line:
    if ch == '"':
      inQuotes = not inQuotes
    elif ch == ',' and not inQuotes:
      fields.add(current.strip())
      current = ""
    else:
      current.add(ch)
  fields.add(current.strip())
  result = fields

# ── Your test suite ──────────────────────────────────────────────────────
# Uncomment and complete each test:

suite "parseCsvLine":
  test "simple comma-separated values":
    check parseCsvLine("a,b,c") == @["a", "b", "c"]

  test "strips whitespace":
    check parseCsvLine(" one , two , three ") == @["one", "two", "three"]

  # Uncomment and complete:
  # test "single value":
  #   check parseCsvLine("solo") == @["___"]

  # test "empty string":
  #   check parseCsvLine("") == @["___"]

  # test "quoted field with comma inside":
  #   check parseCsvLine("\"hello, world\",nim") == @["___", "___"]

  # test "values with leading/trailing spaces":
  #   check parseCsvLine("  alice  ,  bob  ") == @["___", "___"]
