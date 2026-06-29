# nim c -r ex02_fixtures.nim
# Exercise 2: Write tests with setup/teardown for appendToFile
#
# appendToFile opens a file and appends a line. Your job: write tests
# using setup (create temp file) and teardown (remove temp file).

import std/unittest
import std/os

proc appendToFile(path: string, line: string) =
  ## Append a line to the file at `path`. Creates file if needed.
  var f: File
  if open(f, path, fmAppend):
    f.writeLine(line)
    f.close()

# ── Your test suite ──────────────────────────────────────────────────────
# Use setup to create a temp file, teardown to remove it.
# Uncomment and complete:

suite "appendToFile":
  var tempPath: string

  # setup:
  #   # Create temp file in a known location
  #   tempPath = getTempDir() / "ex02_test.txt"
  #   if fileExists(tempPath):
  #     removeFile(tempPath)   # clean slate

  # teardown:
  #   if fileExists(tempPath):
  #     removeFile(tempPath)

  # Uncomment and complete these tests:
  # test "appends line to new file":
  #   appendToFile(tempPath, "first line")
  #   check readFile(tempPath).splitLines()[0] == "___"

  # test "appends to existing file":
  #   appendToFile(tempPath, "line one")
  #   appendToFile(tempPath, "line two")
  #   let lines = readFile(tempPath).splitLines()
  #   check lines.len == ___
  #   check lines[0] == "___"
  #   check lines[1] == "___"

  # test "handles empty string":
  #   appendToFile(tempPath, "")
  #   check readFile(tempPath).strip() == "___"

  test "placeholder — uncomment setup/teardown and tests above, remove this":
    check true
