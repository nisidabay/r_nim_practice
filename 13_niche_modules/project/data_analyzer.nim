# data_analyzer.nim — XML data → rational arithmetic → stats → color report
#   nim c -r project/data_analyzer.nim [--input path/to/data.xml]
#
# Pipeline: parseXml → Rational[int] → RunningStat → color-coded Rope report
# Integrates: xmlparser, rationals, stats, colors, ropes, sugar, lenientops

import std/[parsexml, streams, rationals, stats, colors, ropes, math,
            strutils, os]

# ── CLI flag handling ───────────────────────────────────────────────────

let defaultXml = """<?xml version="1.0"?>
<data>
  <record><value>1/3</value></record>
  <record><value>1/3</value></record>
  <record><value>1/3</value></record>
  <record><value>1/2</value></record>
  <record><value>1/4</value></record>
  <record><value>3/4</value></record>
</data>"""

proc getInputPath(): string =
  for i in 1..paramCount():
    if paramStr(i) == "--input" and i < paramCount():
      return paramStr(i + 1)
  ""

proc loadXmlData(path: string): string =
  if path.len > 0 and fileExists(path):
    readFile(path)
  else:
    defaultXml

# ── XML parsing — extract numeric fractions ────────────────────────────

proc extractFractions(xml: string): seq[string] =
  var s = newStringStream(xml)
  var p: XmlParser
  open(p, s, "data.xml")

  var inValue = false

  while true:
    p.next()
    case p.kind
    of xmlElementStart:
      if p.elementName == "value":
        inValue = true
    of xmlCharData:
      if inValue:
        result.add(p.charData)
        inValue = false
    of xmlEof:
      break
    else:
      discard

  close(p)

# ── Parse fractions → Rational[int] ────────────────────────────────────

proc parseRational(s: string): Rational[int] =
  let parts = s.strip().split('/')
  if parts.len == 2:
    result = initRational(parseInt(parts[0]), parseInt(parts[1]))
  elif parts.len == 1:
    result = initRational(parseInt(parts[0]), 1)
  else:
    result = initRational(0, 1)

# ── ANSI color helpers ──────────────────────────────────────────────────

proc ansiColor(col: Color): string =
  ## Build ANSI 24-bit color escape sequence from a Color value.
  let (r, g, b) = extractRGB(col)
  "\e[38;2;" & $r & ";" & $g & ";" & $b & "m"

proc colorText(text: string, col: Color): string =
  ansiColor(col) & text & "\e[0m"

# ── Main ────────────────────────────────────────────────────────────────

proc main() =
  let inputPath = getInputPath()
  let xml = loadXmlData(inputPath)

  # Step 1: Parse XML → fraction strings
  let fractionStrs = xml.extractFractions()
  echo "Loaded ", fractionStrs.len, " values from XML"

  # Step 2: Parse → Rational[int] for exact arithmetic
  var values: seq[Rational[int]]
  for fs in fractionStrs:
    values.add(parseRational(fs))

  # Compute exact sum and mean
  var sumRat = 0 // 1
  for v in values:
    sumRat = sumRat + v

  let count = values.len
  let meanRat = sumRat / count

  echo "Exact sum:  ", $sumRat
  echo "Exact mean: ", $meanRat

  # Step 3: Convert to float → RunningStat
  var rs: RunningStat
  for v in values:
    rs.push(toFloat(v))

  let mn = round(rs.mean, 2)
  let vr = round(rs.variance, 2)
  let sd = round(rs.standardDeviation, 2)

  # Step 4: Build color-coded report via Ropes
  let green  = parseColor("green")
  let yellow = parseColor("yellow")
  let red    = parseColor("red")
  let cyan   = parseColor("cyan")
  let white  = parseColor("white")

  var report = rope("")
  report = report & rope(colorText("╔════════════════════════════╗\n", cyan))
  report = report & rope(colorText("║    Data Analysis Report    ║\n", cyan))
  report = report & rope(colorText("╚════════════════════════════╝\n", cyan))
  report = report & rope("\n")
  report = report & rope("Samples: ") & rope($count) & rope("\n")
  report = report & rope(colorText("Mean:    ", green)) &
           rope(colorText($mn, white)) & rope("\n")
  report = report & rope(colorText("Variance:", yellow)) &
           rope(colorText($vr, white)) & rope("\n")
  report = report & rope(colorText("StdDev:  ", red)) &
           rope(colorText($sd, white)) & rope("\n")
  report = report & rope("Min:     ") & rope($toFloat(min(values))) & rope("\n")
  report = report & rope("Max:     ") & rope($toFloat(max(values))) & rope("\n")

  # Step 5: Validation
  assert count == fractionStrs.len
  assert meanRat == sumRat / count
  assert abs(rs.mean - toFloat(meanRat)) < 1e-10

  # Print report
  echo ""
  echo $report

when isMainModule:
  main()