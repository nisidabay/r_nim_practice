# nim c -r testing_cli.nim
# How to test CLI code: extract pure procs from main, test those.
# The CLI orchestrates; pure procs do the work you can verify.

import std/unittest
import std/strutils

# ── Pure procs — the testable core ────────────────────────────────────
# Extract ALL logic into pure procs (no I/O, no args parsing).
# These are trivially testable — no files, no CLI, just data in/out.

proc countWords*(text: string): int =
  ## Count whitespace-separated words. Empty string → 0.
  var count = 0
  var inWord = false
  for ch in text:
    if ch in Whitespace:
      inWord = false
    elif not inWord:
      inWord = true
      count += 1
  result = count

proc formatResult*(count: int, filename: string): string =
  ## Format result for display.
  if count == 0:
    filename & ": 0 words (empty)"
  elif count == 1:
    filename & ": 1 word"
  else:
    filename & ": " & $count & " words"

# ── Tests: only test the pure procs ───────────────────────────────────

suite "countWords":
  test "empty string":
    check countWords("") == 0

  test "whitespace only":
    check countWords("   \t\n   ") == 0

  test "normal text":
    check countWords("hello world") == 2
    check countWords("one two three") == 3

  test "single word":
    check countWords("nim") == 1

  test "punctuation doesn't create extra words":
    check countWords("hello, world!") == 2
    check countWords("a, b, c") == 3

  test "leading and trailing whitespace":
    check countWords("  hello  world  ") == 2

suite "formatResult":
  test "zero words":
    check formatResult(0, "test.txt") == "test.txt: 0 words (empty)"

  test "one word":
    check formatResult(1, "data.txt") == "data.txt: 1 word"

  test "many words":
    check formatResult(42, "book.txt") == "book.txt: 42 words"

# ── Why this pattern works ────────────────────────────────────────────
# Pure procs (same input → same output, no side effects) are trivially
# testable: no files, no CLI args, no reading from stdin.
#
# The main block is a thin orchestrator: parse args → call procs → echo.
# You don't need to test it — all the logic lives in the pure procs.
#
# Rule: if you can't test something easily, it probably does too much.
# Extract the pure core and test that.

# ── CLI main (untested — thin orchestrator) ────────────────────────────
# Put this AFTER your test suites so tests run before CLI exit.
# In a real project, you'd put this in a separate file that imports
# the pure procs, keeping tests and CLI completely separate.

when isMainModule:
  import std/os
  if paramCount() < 1:
    echo "Usage: testing_cli <filename>"
    echo "(Run with a text file to see word count in action)"
  else:
    let filename = paramStr(1)
    if not fileExists(filename):
      echo "File not found: ", filename
    else:
      let text = readFile(filename)
      let count = countWords(text)
      echo formatResult(count, filename)

# Try changing:
#   - Add a `countLines` proc and test it.
#   - Change the word definition to split on punctuation too.
#   - Add a test where `countWords` is called with numbers mixed in.
#   - Try testing `when isMainModule` directly (hint: you can't easily).
#   - Run this file directly with a text file as argument.
