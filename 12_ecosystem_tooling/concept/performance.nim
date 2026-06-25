# Performance — debug vs release, optimization flags, compile-time evaluation
#   nim c -r performance.nim           # debug build (fast compile, slow run)
#   nim c -d:release -r performance.nim # release build (slower compile, fast run)

import std/times

# ── 1. Debug vs Release ────────────────────────────────────────────────────

# A deliberately slow function — does 100 million loop iterations.
# In debug mode this is noticeably slow; in release mode it flies.
proc slowSum(n: int): int =
  for i in 0 .. n:
    result += i

echo "Computing sum(1..100_000_000) ..."

let start = getTime()
let total = slowSum(100_000_000)
let elapsed = getTime() - start

echo "Result: ", total
echo "Elapsed: ", $elapsed

echo "\nTry both in your terminal:"
echo "  nim c -r performance.nim              # debug build"
echo "  nim c -d:release -r performance.nim    # release build"
echo "\nSame code — different compiler flags.  The release build runs MUCH faster."
echo "(No bounds checks, no runtime assertions, full optimizer passes.)"

# ── 2. Optimization Flags ──────────────────────────────────────────────────

# Three optimization levels (controlled via --opt: flag):
#
#   --opt:none   → no optimization (default for debug builds)
#   --opt:speed  → optimize for execution speed (default for release builds)
#   --opt:size   → optimize for smaller binary size
#
# Terminal examples:
#
#   # Speed-optimized release (default behavior of -d:release)
#   nim c -d:release -r performance.nim
#
#   # Size-optimized release — smaller binary, slightly slower
#   nim c -d:release --opt:size -r performance.nim
#
#   # Check the binary size difference
#   ls -lh performance
#
# Rule of thumb:
#   --opt:speed → CLI tools, servers, anything user-facing
#   --opt:size  → containers, embedded, space-constrained environments

# ── 3. Compile-Time Evaluation ─────────────────────────────────────────────

# Functions can run at COMPILE TIME when assigned to a const.
# The Nim compiler evaluates the code and bakes the result into the binary.
# Zero runtime cost.

func sumTo(n: int): int =
  for i in 1 .. n:
    result += i

# This loop runs inside the Nim compiler, not at runtime
const millionSum = sumTo(1_000_000)

echo "\nSum of 1..1,000,000 (computed at compile time): ", millionSum
echo "That value is baked into the binary — no runtime loop needed."

# ── 4. Principle: Make It Work, Then Make It Fast ─────────────────────────

# The slowSum code above never changes between debug and release.
# Only the COMPILER FLAGS change.
#
# Development workflow:
#   1. Write and iterate with debug builds     (nim c -r performance.nim)
#   2. When the logic is correct, switch flags  (add -d:release)
#   3. Profile if needed, tune with --opt:size / --opt:speed
#
# "First make it work, then make it fast."
# The compiler does the heavy lifting — you focus on correct code.
