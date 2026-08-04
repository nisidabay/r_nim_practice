# nim c -r fixtures.nim
# setup/teardown: create and destroy test resources automatically.
# Every test in a suite gets its own fresh setup — no stale state.

import std/unittest
import std/os

# ── Proc under test — depends on a file ───────────────────────────────

proc fileLength(path: string): int =
  ## Return number of bytes in file.
  result = readFile(path).len

# ── Suite with setup and teardown ─────────────────────────────────────

suite "fileLength":
  var path: string              # mutable — set in setup, used in tests

  setup:
    # Runs BEFORE each test. Create a fresh temp file.
    path = getTempDir() / "unittest_demo.txt"
    writeFile(path, "hello")

  teardown:
    # Runs AFTER each test. Clean up, even if test fails.
    if fileExists(path):
      removeFile(path)

  test "returns correct length":
    writeFile(path, "hello world")      # override with known content
    check fileLength(path) == 11

  test "empty file returns 0":
    writeFile(path, "")                 # empty override
    check fileLength(path) == 0

  test "single character returns 1":
    writeFile(path, "x")
    check fileLength(path) == 1

# Key behaviors:
#   1. setup runs before EVERY test — each test starts fresh.
#   2. teardown runs after EVERY test — even if the test fails.
#   3. No test can leak state to the next test.

# ── Mutable state gotcha ──────────────────────────────────────────────

suite "counter test (mutable state pitfall)":
  var count = 0                 # suite-level var — shared across tests!

  test "increment once":
    count += 1
    check count == 1

  test "increment again":
    # count is STILL 1 from the previous test! (no per-test reset)
    count += 1
    check count == 2             # passes ONLY because we know this

  # Moral: suite-level `var` persists between tests. Use setup/teardown
  # for per-test state. Only use suite-level `let` for shared constants.

# ── What teardown looks like in practice ──────────────────────────────
# setup:    open database connection / create temp file / allocate resource
# tests:    read/write/query
# teardown: close connection / delete temp file / free resource

# Try changing:
#   - Remove the teardown and check if the temp file persists.
#   - Add `echo "setting up"` in setup and `echo "tearing down"` in teardown.
#   - Move `var path` into setup — why does that NOT work?
#   - Add a test that runs without setup writing the file — what happens?
#   - Replace `getTempDir()` with a fixed path like "/tmp/demo.txt".

# ── Thinking in Nim ────────────────────────────
# setup/teardown are first-class blocks in std/unittest, so test resources
# are a feature, not a convention you have to hand-roll. Combined with
# Nim's mutable/immutable distinction — `var` for per-test state, `let`
# for shared constants — the suite makes it obvious which state leaks
# between tests and which does not.
