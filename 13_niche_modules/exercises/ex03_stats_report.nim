# ex03_stats_report.nim — stats → color-coded rope report
#   nim c -r exercises/ex03_stats_report.nim

import std/stats, std/ropes, std/colors, std/math, std/strutils

# ── ANSI color helpers ──────────────────────────────────────────────────

proc colorize(text: string, col: Color): string =
  let (r, g, b) = extractRGB(col)
  "\e[38;2;" & $r & ";" & $g & ";" & $b & "m" & text & "\e[0m"

# ── Compute stats ───────────────────────────────────────────────────────

var s: RunningStat
for x in [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]:
  s.push(x)

let mn = round(s.mean, 2)
let vr = round(s.variance, 2)
let sd = round(s.standardDeviation, 2)

# ── Build color-coded report ───────────────────────────────────────────

var report = rope("Statistics Report\n")
report = report & rope("=================\n")
report = report & rope("Count: ") & rope($s.n) & rope("\n")
report = report & rope("Mean:  ") & rope(colorize($mn, parseColor("green"))) & rope("\n")
report = report & rope("Var:   ") & rope(colorize($vr, parseColor("yellow"))) & rope("\n")
report = report & rope("Std:   ") & rope(colorize($sd, parseColor("red"))) & rope("\n")
report = report & rope("=================\n")

echo $report

let outStr = $report

# ── Verification ────────────────────────────────────────────────────────

assert s.n == 8
assert abs(s.mean - 5.0) < 1e-10
assert outStr.contains("Mean:")
assert outStr.contains("Var:")
assert outStr.contains("Std:")
assert outStr.contains("\e[")   # ANSI escape present

echo "ex03_stats_report: All assertions passed."