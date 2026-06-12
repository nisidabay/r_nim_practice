# Exercise 2: CSV Log Stats — parsecsv + logging
#   nim c -r ex02_csv_log_stats.nim
#
# Parses a CSV log file and outputs per-level counts via structured logging.
# Demonstrates: CsvParser, readHeaderRow, logging levels

import std/parsecsv
import std/logging
import std/os
import std/tables

# ── Create sample CSV log ───────────────────────────────────────────────

let csvLog = """timestamp,level,message
2026-06-11 10:00:00,INFO,Server started
2026-06-11 10:01:00,ERROR,Connection timeout on port 8080
2026-06-11 10:02:00,WARN,Memory usage above 80%
2026-06-11 10:03:00,INFO,Request processed in 45ms
2026-06-11 10:04:00,ERROR,Database connection lost
2026-06-11 10:05:00,INFO,Health check passed
2026-06-11 10:06:00,WARN,Disk space at 85%
2026-06-11 10:07:00,DEBUG,Cache hit ratio: 0.92
2026-06-11 10:08:00,INFO,New user registered
2026-06-11 10:09:00,FATAL,Out of memory — process terminated
"""

let csvPath = "/tmp/nim_ex02_log.csv"
writeFile(csvPath, csvLog)

# ── Setup logging ───────────────────────────────────────────────────────

var logger = newConsoleLogger(fmtStr = "$levelid: $msg")
addHandler(logger)

# ── Parse CSV and count levels ──────────────────────────────────────────

var parser: CsvParser
parser.open(csvPath, separator = ',', quote = '"')
parser.readHeaderRow()

var counts = initTable[string, int]()

while parser.readRow():
  let level = parser.rowEntry("level")
  counts[level] = counts.getOrDefault(level, 0) + 1

parser.close()

# ── Output counts via logging ──────────────────────────────────────────

info("CSV log parsing complete")
info("File: " & csvPath)
echo ""  # visual separation

for level, count in counts:
  case level
  of "FATAL", "ERROR":
    log(lvlError, level & ": " & $count & " entries")
  of "WARN":
    log(lvlWarn, level & ": " & $count & " entries")
  of "INFO":
    log(lvlInfo, level & ": " & $count & " entries")
  else:
    log(lvlDebug, level & ": " & $count & " entries")

# ── Summary ─────────────────────────────────────────────────────────────

let total = parser.processedRows()
echo ""
log(lvlInfo, "Total rows parsed: " & $total)

# Cleanup
removeFile(csvPath)