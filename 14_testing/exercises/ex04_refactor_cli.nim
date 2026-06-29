# nim c -r ex04_refactor_cli.nim
# Exercise 4: Refactor a monolithic CLI and write tests
#
# Below is a file statistics tool. The original code was a single monolithic
# `when isMainModule` block (shown at the bottom). It has been REFACTORED
# into pure procs. Your job: write tests for these procs.

import std/unittest
import std/strutils

# ── Refactored pure procs (extracted from the monolithic block below) ──

proc countLines*(text: string): int =
  ## Return number of lines counting each '\n' as a line boundary.
  if text.len == 0: return 0
  result = 1
  for ch in text:
    if ch == '\n':
      result += 1

proc countWords*(text: string): int =
  ## Return number of whitespace-separated words.
  var inWord = false
  for ch in text:
    if ch in Whitespace:
      inWord = false
    elif not inWord:
      inWord = true
      result += 1

proc countChars*(text: string): int =
  ## Return number of characters (includes newlines).
  text.len

# ── Your test suites ────────────────────────────────────────────────────
# Uncomment and complete:

suite "countLines":
  test "empty string":
    check countLines("") == 0

  test "single line":
    check countLines("hello") == 1

  test "multiple lines":
    check countLines("line1\nline2\nline3") == 3

  # Uncomment and add more:
  # test "trailing newline counts correctly":
  #   check countLines("hello\n") == ___

  # test "only newline is one line":
  #   check countLines("\n") == ___

suite "countWords":
  test "empty string":
    check countWords("") == 0

  test "normal text":
    check countWords("one two three") == 3

  # Uncomment and add more:
  # test "whitespace only":
  #   check countWords("   \t\n  ") == ___

  # test "single word":
  #   check countWords("nim") == ___

  # test "with punctuation":
  #   check countWords("hello, world!") == ___

suite "countChars":
  test "empty string":
    check countChars("") == 0

  test "short string":
    check countChars("abc") == 3

  # Uncomment and add more:
  # test "multiline includes newlines":
  #   check countChars("a\nb\nc") == ___

# ── Original monolithic code (what we refactored from) ──────────────────
# This was the original, untestable version. All logic was buried in a
# `when isMainModule` block that called quit(). Compare to the refactored
# procs above:
#
# when isMainModule:
#   if paramCount() < 1:
#     echo "Usage: file_stats <filename>"
#     quit(1)
#   let filename = paramStr(1)
#   if not fileExists(filename):
#     echo "File not found: ", filename
#     quit(1)
#   let text = readFile(filename)
#   var lineCount = 0
#   for ch in text:
#     if ch == '\n':
#       lineCount += 1
#   if text.len > 0: lineCount += 1
#   var wordCount = 0
#   var inWord = false
#   for ch in text:
#     if ch in Whitespace:
#       inWord = false
#     elif not inWord:
#       inWord = true; wordCount += 1
#   echo filename, ": ", lineCount, " lines, ", wordCount,
#     " words, ", text.len, " chars"

# Try: extract procs from any of your own CLI tools and test them.
# Try: add a `countSentences` proc and test it.
# Try: use setup/teardown to test with temp files instead of strings.
