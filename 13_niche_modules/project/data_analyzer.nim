# data_analyzer.nim — Read text data → stats → color-coded report
#   nim c -r project/data_analyzer.nim [--input path/to/data.txt]
#
# Pipeline: readFile → float → RunningStat → color-coded report
# Integrates: stats, colors, math, strutils, os
#
# Data file format: one number per line, plain text. Fractions like 1/3 accepted.

import std/[stats, math, strutils, os]

# ── Default data (inline, no file needed to run) ──────────────────────────

const defaultData = """
1/3
1/3
1/3
1/2
1/4
3/4
"""

# ── CLI flag handling ───────────────────────────────────────────────────

proc getInputPath(): string =
  for i in 1..paramCount():
    if paramStr(i) == "--input" and i < paramCount():
      return paramStr(i + 1)
  ""

# ── Read data file or use default ───────────────────────────────────────

proc loadData(path: string): string =
  if path.len > 0 and fileExists(path):
    readFile(path)
  else:
    defaultData

# ── Parse each line → float ─────────────────────────────────────────────

proc parseLine(s: string): float =
  let parts = s.strip().split('/')
  if parts.len == 2:
    result = parseFloat(parts[0]) / parseFloat(parts[1])
  elif parts.len == 1:
    result = parseFloat(parts[0])
  else:
    result = 0.0

# ── ANSI color helpers ──────────────────────────────────────────────────

proc ansiCode(name: string): string =
  case name
  of "green": "\e[32m"
  of "yellow": "\e[33m"
  of "red": "\e[31m"
  of "cyan": "\e[36m"
  of "white": "\e[37m"
  else: "\e[0m"

proc colorText(text: string, ansi: string): string =
  ansi & text & "\e[0m"

# ── Main ────────────────────────────────────────────────────────────────

proc main() =
  let inputPath = getInputPath()
  let raw = loadData(inputPath)

  # Parse lines → floats (skip blanks)
  var values: seq[float]
  for line in raw.splitLines():
    let trimmed = line.strip()
    if trimmed.len > 0:
      values.add(parseLine(trimmed))

  echo "Loaded ", values.len, " values"

  # Compute sum and mean
  var sumF: float = 0.0
  for v in values:
    sumF = sumF + v

  let count = values.len
  let meanF = sumF / count.float

  echo "Sum:  ", sumF
  echo "Mean: ", meanF

  # Feed into RunningStat
  var rs: RunningStat
  for v in values:
    rs.push(v)

  let mn = round(rs.mean, 2)
  let vr = round(rs.variance, 2)
  let sd = round(rs.standardDeviation, 2)

  # Build color-coded report
  let green  = ansiCode("green")
  let yellow = ansiCode("yellow")
  let red    = ansiCode("red")
  let cyan   = ansiCode("cyan")
  let white  = ansiCode("white")

  var report = ""
  report &= colorText("╔════════════════════════════╗\n", cyan)
  report &= colorText("║    Data Analysis Report    ║\n", cyan)
  report &= colorText("╚════════════════════════════╝\n", cyan)
  report &= "\n"
  report &= "Samples: " & $count & "\n"
  report &= colorText("Mean:    ", green) & colorText($mn, white) & "\n"
  report &= colorText("Variance:", yellow) & colorText($vr, white) & "\n"
  report &= colorText("StdDev:  ", red) & colorText($sd, white) & "\n"
  report &= "Min:     " & $min(values) & "\n"
  report &= "Max:     " & $max(values) & "\n"

  # Validation
  assert count == values.len
  assert abs(meanF - sumF / count.float) < 1e-10
  assert abs(rs.mean - meanF) < 1e-10

  # Print report
  echo ""
  echo report

when isMainModule:
  main()
