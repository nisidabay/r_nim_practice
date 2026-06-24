# Read a log file, filter by severity level, print summary
#   nim c -r scripts/log_tail.nim <file> [level]
#
# Example:
#   nim c -r scripts/log_tail.nim /var/log/syslog ERROR

import std/[os, strutils, tables]

if paramCount() < 1:
  echo "Usage: log_tail <file> [level]"
  echo "  e.g. log_tail /var/log/syslog ERROR"
  quit(1)

let path = paramStr(1)
let level = if paramCount() >= 2: paramStr(2).toUpperAscii() else: "ERROR"

if not fileExists(path):
  echo "Error: file not found: ", path
  quit(1)

let lines = readFile(path).splitLines()
var matches: seq[int] = @[]
var counts: CountTable[string]

for i, line in lines:
  if line.toUpperAscii().contains(level):
    matches.add(i + 1)  # 1-indexed
  # Collect all severity levels for summary
  let upper = line.toUpperAscii()
  for sev in ["DEBUG", "INFO", "WARN", "ERROR", "FATAL"]:
    if upper.contains(sev):
      counts.inc(sev)
      break

echo "── ", path, " ──"
echo "Filter: ", level
echo "Matches: ", matches.len, " of ", lines.len, " lines"
echo ""

if matches.len > 0 and matches.len <= 30:
  for i in matches:
    echo i, ": ", lines[i - 1]
elif matches.len > 30:
  echo "(Showing first 30 of ", matches.len, " matches)"
  for i in matches[0 ..< 30]:
    echo i, ": ", lines[i - 1]

echo ""
echo "── Severity summary ──"
for sev in ["DEBUG", "INFO", "WARN", "ERROR", "FATAL"]:
  if sev in counts:
    echo sev, ": ", counts[sev]
