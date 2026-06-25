# nim c -r debugging.nim
# assert, echo, stacktraces, instantiationInfo, quit vs raise — debugging tools.

# ── assert ───────────────────────────────────────────────────────────────

echo "=== assert ==="

assert 1 + 1 == 2
echo "1 + 1 == 2 passed"

# Uncomment to see assertion failure:
# assert 1 + 1 == 3
# Output: [AssertionDefect] assertion.nim(17) 1 + 1 == 3
#
# Line number and expression are printed automatically.
# Use assert to enforce invariants inside functions:

proc positive(n: int): int =
  assert n > 0, "n must be positive, got: " & $n
  result = n * 2

echo "positive(5) = ", positive(5)
# positive(-1)  # would fail: [AssertionDefect] n > 0  n must be positive, got: -1


# ── Echo debugging ───────────────────────────────────────────────────────

echo "\n=== echo debugging ==="

proc compute(x, y: int): int =
  echo "[trace] entered compute, x = ", x, " y = ", y
  let step1 = x + y
  echo "[trace] step1 = ", step1
  let step2 = step1 * 2
  echo "[trace] step2 = ", step2
  result = step2

echo "result = ", compute(3, 4)

# echo writes to stdout by default.
# stderr.writeLine() writes to stderr — useful when stdout is redirected:
stderr.writeLine("[stderr] this goes to stderr, not stdout")


# ── Stacktraces ──────────────────────────────────────────────────────────

echo "\n=== stacktraces ==="

proc innerBuggy(a, b: int): int =
  if b == 0:
    raise newException(ValueError, "innerBuggy: division by zero")
  result = a div b

proc middleBuggy(x: int): int =
  result = innerBuggy(x, 0)    # passes 0 as denominator

proc outerBuggy(seed: int): int =
  result = middleBuggy(seed) * 2

try:
  echo outerBuggy(42)
except:
  let e = getCurrentException()
  # e.getStackTrace() returns the trace at the point the exception was raised.
  echo "Caught: ", e.msg
  echo "Stacktrace:\n", e.getStackTrace()

# How to read (from the output above):
#   debugging.nim(61) → where the try/except was (closest to the catch)
#   outerBuggy(58)    → called middleBuggy
#   middleBuggy(55)   → called innerBuggy
#   innerBuggy(51)    → where the exception was actually raised
#
# With nim c -r, line numbers and function names appear by default.
# For fatal defects (IndexDefect, NilAccessDefect) the trace prints
# to stderr and the program exits — those can't be caught.


# ── instantiationInfo ────────────────────────────────────────────────────

echo "=== instantiationInfo ==="

# instantiationInfo() only works inside templates — at the top level
# it returns default values (??? / 0). Put it in a template helper:
template dbg(msg: string) =
  echo instantiationInfo().filename, ":", instantiationInfo().line, " — ", msg

dbg("hello from a template helper")
dbg("notice how line numbers change per call site")

# Each dbg() call expands at its call site, so line numbers are correct.


# ── quit(1) vs exceptions ────────────────────────────────────────────────

echo "\n=== quit vs exceptions ==="

# quit(1) — immediate exit with exit code. Use for fatal, unrecoverable errors.
#   - Bad CLI arguments, missing config file, cannot open critical resource.
#   - No try/except can catch it; the program stops right there.

# Uncomment to see quit in action:
# echo "About to quit..."
# quit("Missing required argument: --input", 1)
# echo "This never prints"

# raise — creates an exception that can be caught. Use for recoverable errors.
#   - Invalid user input in a loop, network timeouts, data validation.

proc safeDiv(a, b: int): int =
  if b == 0:
    raise newException(ValueError, "division by zero: " & $a & " / " & $b)
  result = a div b

echo "safeDiv(10, 2) = ", safeDiv(10, 2)

try:
  echo safeDiv(10, 0)
except ValueError as e:
  echo "Recovered from: ", e.msg

# Rule of thumb:
#   quit(1)  — the program cannot continue at all
#   raise    — the caller might want to handle it and try again
