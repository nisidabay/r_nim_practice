# std/stats — online statistics (running mean, variance, stddev)
#   nim c -r concept/stats.nim

import std/stats

# ── Basic usage ─────────────────────────────────────────────────────────

var s: RunningStat

s.push(2)
s.push(4)
s.push(4)
s.push(4)
s.push(5)
s.push(5)
s.push(7)
s.push(9)

echo "n       = ", s.n          # 8
echo "mean    = ", s.mean       # 5.0
echo "variance = ", s.variance  # 4.0 (population variance)
echo "stddev   = ", s.standardDeviation  # 2.0

# ── Incremental: push more, stats update ────────────────────────────────

s.push(10)
s.push(10)
echo "After 2 more: n = ", s.n, ", mean = ", s.mean

# ── Multiple sequential stats ───────────────────────────────────────────

var s2: RunningStat
for x in [1.0, 2.0, 3.0, 4.0, 5.0]:
  s2.push(x)

echo "1..5 mean = ", s2.mean, ", stddev = ", s2.standardDeviation

# ── Verification ────────────────────────────────────────────────────────

assert s.n == 10
assert abs(s.mean - 6.0) < 1e-10

var sv: RunningStat
for x in [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]:
  sv.push(x)
assert abs(sv.mean - 5.0) < 1e-10
assert sv.n == 8
assert abs(sv.standardDeviation - 2.0) < 1e-10

echo "All stats assertions passed."