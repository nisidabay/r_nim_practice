# ex03_stats_report.nim — stats → color-coded report
#   nim c -r exercises/ex03_stats_report.nim

import std/stats, std/math, std/strutils

# ── ANSI color helpers ──────────────────────────────────────────────────

proc colorize(text: string, code: string): string =
  code & text & "\e[0m"

# ── Compute stats ───────────────────────────────────────────────────────

var s: RunningStat
for x in [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]:
  s.push(x)

let mn = round(s.mean, 2)
let vr = round(s.variance, 2)
let sd = round(s.standardDeviation, 2)

# ── Build color-coded report ───────────────────────────────────────────

var report = "Statistics Report\n"
report &= "=================\n"
report &= "Count: " & $s.n & "\n"
report &= "Mean:  " & colorize($mn, "\e[32m") & "\n"
report &= "Var:   " & colorize($vr, "\e[33m") & "\n"
report &= "Std:   " & colorize($sd, "\e[31m") & "\n"
report &= "=================\n"

echo report

# ── Verification ────────────────────────────────────────────────────────

assert s.n == 8
assert abs(s.mean - 5.0) < 1e-10
assert report.contains("Mean:")
assert report.contains("Var:")
assert report.contains("Std:")
assert report.contains("\e[")   # ANSI escape present

echo "ex03_stats_report: All assertions passed."